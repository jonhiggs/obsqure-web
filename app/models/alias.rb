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
    address = nil
    attempt = 0
    while Alias.find_by_address(address) || address.nil?
      attempt += 1
      length = 6
      chars = (0..9).to_a + ("A".."Z").to_a
      name = length.times.map{ (chars[rand(chars.size)].to_s) }.join
      address = "#{name}@obsqure.me"
      puts "attempt number: #{attempt}".inspect
      raise "alias namespace is getting exhausted" if attempt > 20
    end
    address
  end
end
