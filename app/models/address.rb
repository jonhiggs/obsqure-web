class Address < ActiveRecord::Base
  belongs_to :user
  has_many :aliases
  validates :to, :presence => true, :email => true
  before_destroy :check_for_aliases
  before_save :manage_token
  after_save :update_default_email
  after_save :unverify_if_address_changed
  after_save :verify_aliases_if_validated

  def check_for_aliases
    if !aliases.count.zero?
      flash[:error] = "Cannot delete addresses that have aliases."
      false
    end
  end

  def unverify_if_address_changed
    self.verified = false if self.to_changed?
    PostfixAlias.where(:to => self.to).delete_all
  end

  def verify_aliases_if_validated
    if self.verified?
      self.aliases.each do |a|
        pfa = PostfixAlias.new
        pfa.from = a.to
        pfa.to = self.to
        pfa.save!
      end
    end
  end

  def update_default_email
    user = User.find_by_id(self.user_id)

    if !user.has_email?
      user.email = self.id
      user.save!
    end
  end

private
  def manage_token
    if self.verified? && self.token?
      self.token = nil
    end

    if !self.verified?
      self.verified = false
      chars = (0..9).to_a + ("A".."Z").to_a + ("a".."z").to_a
      self.token = 32.times.map{ (chars[rand(chars.size)].to_s) }.join
    end
  end

end
