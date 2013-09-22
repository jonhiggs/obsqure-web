class Alias < ActiveRecord::Base
  belongs_to :user
  validates :name, :presence => true
  before_save :generate_address
  after_create :save_postfix_alias
  after_destroy :destroy_postfix_alias

  def address
    Address.find_by_id(self.address_id)
  end

  def verified?
    address.verified?
  end

protected
  def save_postfix_alias
    postfix_alias = PostfixAlias.new()
    postfix_alias.from = self.to
    postfix_alias.to = self.address
    postfix_alias.save
  end

  def destroy_postfix_alias
    PostfixAlias.where(:from => self.to).delete_all
  end

private
  def generate_address
    return true unless self.to.nil?

    attempt = 0
    found_address = nil
    while Alias.find_by_to(found_address) || found_address.nil?
      attempt += 1
      length = 6
      chars = (0..9).to_a + ("A".."Z").to_a
      name = length.times.map{ (chars[rand(chars.size)].to_s) }.join
      found_address = "#{name}@obsqure.me"
      raise "alias namespace is getting exhausted" if attempt > 20
    end
    self.to = found_address
  end

end
