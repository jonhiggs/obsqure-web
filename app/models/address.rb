class Address < ActiveRecord::Base
  belongs_to :user
  has_many :aliases
  validates :to, :presence => true, :email => true
  before_destroy :check_for_aliases
  after_create :generate_token
  after_save :update_default_email
  after_save :unverify_if_address_changed

  def check_for_aliases
    if !aliases.count.zero?
      flash[:error] = "Cannot delete addresses that have aliases."
      false
    end
  end

  def unverify_if_address_changed
    self.verified = false if self.to_changed?
  end
  
  def update_default_email
    user = User.find_by_id(self.user_id)

    if !user.has_email?
      user.email = self.id
      user.save!
    end
  end

  def generate_token
    self.verified = false
    chars = (0..9).to_a + ("A".."Z").to_a + ("a".."z").to_a
    self.token = 32.times.map{ (chars[rand(chars.size)].to_s) }.join
    self.save
  end

end
