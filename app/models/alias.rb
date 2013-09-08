class Alias < ActiveRecord::Base
  belongs_to :user
  before_save :generate_address

  def generate_address
    length = 8
    chars = (0..9).to_a + ("A".."Z").to_a
    name = length.times.map{ (chars[rand(chars.size)].to_s) }.join
    self.address ||= "#{name}@obsqure.me"
  end
end
