require File.dirname(__FILE__) + '/../test_helper'
require 'action_view/test_case'

class ApplicationHelperTest < ActionView::TestCase
  test 'flash_messages' do
    user = User.first
    user.aliases.each{|a| a.destroy!}
    user.addresses.each{|address| address.destroy!}
    address1 = Address.new(:user_id => user.id, :to => "real@address.com")
    address1.save

    flash_messages(address1)
    assert flash[:error].nil?

    address1.to = "abcd"
    address1.save
    flash_messages(address1)
    assert_equal "Email address does not appear to be valid", flash[:error]
  end
end
