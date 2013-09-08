class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :trackable, :recoverable
  devise :database_authenticatable, :registerable, :validatable, :rememberable
  has_many :aliases
end
