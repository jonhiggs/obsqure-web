class Address < ActiveRecord::Base
  belongs_to :user
  has_many :aliases
  validates :to, :presence => true, :email => true
  before_destroy :check_for_aliases
  after_save :update_default_email
  after_save :unverify_if_email_changed

  def check_for_aliases
    if !aliases.count.zero?
      flash[:error] = "Cannot delete addresses that have aliases."
      false
    end
  end

  def unverify_if_email_changed
    self.unverify if self.to_changed?
  end

  def update_default_email
    user = User.find_by_id(self.user_id)

    if !user.has_email?
      user.email = self.id
      user.save!
    end
  end

  def verified?
    self.token.nil?
  end

  def verify
    self.token = nil
    self.aliases.each do |a|
      pfa = PostfixAlias.new
      pfa.from = a.to
      pfa.to = self.to
      pfa.save!
    end
  end

  def default?
    self.id == User.find_by_id(self.user_id).email
  end

  def unverify
    self.token = self.generate_token
    PostfixAlias.where(:to => self.to).delete_all
  end

protected
  def generate_token
    chars = (0..9).to_a + ("A".."Z").to_a + ("a".."z").to_a
    32.times.map{ (chars[rand(chars.size)].to_s) }.join
  end
end
