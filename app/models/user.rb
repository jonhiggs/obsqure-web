class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :trackable, :recoverable
  devise :database_authenticatable, :registerable, :validatable, :rememberable
  has_many :addresses
  has_many :aliases, through: :addresses

  def default_address
    self.has_default_address? ? self.addresses.default(self.id).first : nil
  end

  def has_default_address?
    !self.default_address.nil?
  end

  def has_verified_address?
    self.verified_addresses.empty?
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
    self.addresses.map{|a| a if a.verified}
  end


  #  @addresses = user.addresses.verified(current_user)
  #  if user.has_default_address?
  #    @default_address = user.default_address.id
  #  else
  #    @default_address = nil
  #  end
  #end

protected
  def unset_default_address(id)
    address = Address.find_by_id(default_address.id)
    address.default=false
    address.save
  end
end
