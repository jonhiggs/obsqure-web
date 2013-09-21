class PostfixAlias < ActiveRecord::Base
  validates :from, :presence => true, :email => true, :uniqueness => true
  validates :to,   :presence => true, :email => true
  
end
