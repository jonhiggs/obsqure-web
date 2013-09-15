class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :trackable, :recoverable
  devise :database_authenticatable, :registerable, :validatable, :rememberable
  has_many :addresses
  has_many :aliases, through: :addresses

  def default_address
    self.addresses.default(self.id).first
  end

  def has_default_address?
    !self.addresses.default(self.id).empty?
  end

  def default_address=(id)
    self.unset_default_address(id) if self.has_default_address?
    address = Address.find_by_id(id)
    address.default=true
    address.save
  end

protected
  def unset_default_address(id)
    address = Address.find_by_id(default_address.id)
    address.default=false
    address.save
  end
end
