class Alias < ActiveRecord::Base
  belongs_to :user
  before_save :redirect_to
  before_save :save_defaults


  def save_defaults
    self.redirect_to ||= self.user.email
    self.address ||= generate_address
  end

private
  def generate_address
    length = 8
    chars = (0..9).to_a + ("A".."Z").to_a
    name = length.times.map{ (chars[rand(chars.size)].to_s) }.join
    "#{name}@obsqure.me"
  end
end
