class Address < ActiveRecord::Base
  belongs_to :user
  has_many :aliases
  validates :to, :presence => true, :email => true
end
