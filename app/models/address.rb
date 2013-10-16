class Address < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :user
  has_many :aliases
  validates :to, :uniqueness => {:message => "Email address has already been taken"}
  validates :to, :presence => {:message => "You must supply an email address"}
  validates :to, :email => {:message => "Email address does not appear to be valid"}
  validates :token, :presence => true

  after_initialize :set_token
  before_create :allowed_to_create?

  before_destroy :check_for_aliases
  after_destroy :delete_address_id_from_user

  before_save :unverify_if_email_changed
  before_save :user_exists?
  after_save :update_address_id
  after_save :send_verification_email

  def user_exists?
    unless User.find_by_id(self.user_id)
      errors.add(:user_id, "user does not exist")
      false
    end
  end

  def send_verification_email
    return true if self.token.nil?
    if self.to_changed?
      Notifier.verify(self).deliver
    end
  end

  def delete_address_id_from_user
    user = User.find_by_address_id(self.id)
    unless user.nil?
      user.address_id = nil
      user.save!
    end
  end

  def set_token
    self.token = self.generate_token
  end

  def check_for_aliases
    if !aliases.count.zero?
      errors.add(:user_id, "You cannot delete addresses that still have aliases.")
      false
    end
  end

  def allowed_to_create?
    if User.find_by_id(self.user_id).has_maximum_addresses?
      errors.add(:user_id, "You have created the maximum number of allowed addresses.")
      return false
    end

    if self.to.match(/\@obsqure.me$/)
      errors.add(:to, "The address has a disallowed domain.")
      return false
    end
  end

  def unverify_if_email_changed
    if self.to_changed? && !self.to_was.nil?
      self.unverify 
    end
  end

  def update_address_id
    user = User.find_by_id(self.user_id)
    user.address_id = self.id if self.verified?
    user.save!
  end

  def verified?
    self.token == "verified"
  end

  def verify
    self.token = "verified"
    Alias.where(:address_id => self.id).each do |a|
      pfa = PostfixAlias.new
      pfa.from = a.to
      pfa.to = self.to
      pfa.save!
    end
  end

  def verify!
    self.verify
    self.save!
  end

  def verify_link
    url = "http://www.obsqure.net/verify"
    self.verified? ? url : url + "/#{self.token}"
  end

  def default?
    self.id == User.find_by_id(self.user_id).address_id
  end

  def unverify
    self.token = nil
    self.token = self.generate_token
    PostfixAlias.where(:to => self.to).delete_all
    PostfixAlias.where(:to => self.to_was).delete_all
  end

protected
  def generate_token
    return self.token unless self.token.nil?
    chars = (0..9).to_a + ("A".."Z").to_a + ("a".."z").to_a
    32.times.map{ (chars[rand(chars.size)].to_s) }.join
  end
end
