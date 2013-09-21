class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :trackable, :recoverable
  devise :database_authenticatable, :registerable, :validatable, :rememberable,
         :authentication_keys => [:username]

  validates :username, :uniqueness => { :case_sensitive => false }
  has_many :addresses
  has_many :aliases, through: :addresses

  def email_required?
    false
  end

  def default_address
    self.has_default_address? ? self.addresses.default(self.id).first : nil
  end

  def has_default_address?
    !self.default_address.nil?
  end

  def has_verified_address?
    self.verified_addresses.is_a?(Array)
  end

  def has_aliases?
    self.aliases.empty?
  end

  def alias(id)
    self.aliases.select{|a| a.id.to_i == id.to_i }.first
  end

  def address(id)
    self.addresses.select{|a| a.id.to_i == id.to_i }.first
  end

  def default_address
    defaults = self.addresses.map{|a| a if a.default}
    defaults.empty? ? nil : defaults.first
  end

  def aliases_sorted
    self.aliases.sort_by{|a| a.name}
  end

  def verified_addresses
    result = self.addresses.map{|a| a if a.verified}
    return false if result.compact.empty?
    result
  end

  def maximum_addresses
    self.account_type == 0 ? "1" : "∞"
  end

  def maximum_aliases
    self.account_type == 0 ? "5" : "∞"
  end

  def used_addresses
    self.addresses.count
  end

  def used_aliases
    self.aliases.count
  end

  def has_maximum_addresses?
    self.used_addresses.to_s >= self.maximum_addresses
  end

  def has_maximum_aliases?
    self.used_aliases.to_s >= self.maximum_aliases
  end

protected
  def unset_default_address(id)
    address = Address.find_by_id(default_address.id)
    address.default=false
    address.save
  end
end
