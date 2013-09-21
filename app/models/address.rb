class Address < ActiveRecord::Base
  belongs_to :user
  has_many :aliases
  validates :to, :presence => true, :email => true
  before_destroy :check_for_aliases

  def check_for_aliases
    if !aliases.count.zero?
      flash[:error] = "Cannot delete addresses that have aliases."
      false
    end
  end

#  scope :default, lambda {|user_id| { 
#    :conditions => {
#      :user_id => user_id,
#      :default => true
#    }
#  }} 
#
#  scope :verified, lambda {|user_id| { 
#    :conditions => {
#      :user_id => user_id,
#      :verified => true
#    }
#  }} 

end
