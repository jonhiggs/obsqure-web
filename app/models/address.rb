class Address < ActiveRecord::Base
  belongs_to :user
  has_many :aliases
  validates :to, :presence => true, :email => true
  validates :token, :presence => true
  before_create :allowed_to_create?
  after_initialize :set_token
  before_destroy :check_for_aliases
  after_save :update_default_email
  before_save :unverify_if_email_changed
  before_save :user_exists?

  def user_exists?
    unless User.find_by_id(self.user_id)
      errors.add(:user_id, "user does not exist")
      false
    end
  end

  def set_token
    self.token = self.generate_token
  end

  def check_for_aliases
    if !aliases.count.zero?
      errors.add(:user_id, "cannot delete addresses that have aliases")
      false
    end
  end

  def allowed_to_create?
    if User.find_by_id(self.user_id).has_maximum_addresses?
      errors.add(:user_id, "you have created the maximum number of allowed addresses")
      false
    end
  end

  def unverify_if_email_changed
    if self.to_changed? && !self.to_was.nil?
      self.unverify 
    end
  end

  def update_default_email
    user = User.find_by_id(self.user_id)

    # TODO: change this to an ||=
    if !user.has_email?
      user.address_id = self.id
      user.save!
    end
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
