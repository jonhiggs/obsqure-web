class Address < ActiveRecord::Base
  belongs_to :user
  has_many :aliases
  validates :to, :presence => true, :email => true

  scope :default, lambda {|user_id| { 
    :conditions => {
      :user_id => user_id,
      :default => true
    }
  }} 

  scope :verified, lambda {|user_id| { 
    :conditions => {
      :user_id => user_id,
      :verified => true
    }
  }} 

end
