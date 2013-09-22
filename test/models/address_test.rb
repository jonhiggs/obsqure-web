require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  setup do
    @user1 = User.find_by_id(1)
    @user2 = User.find_by_id(2)
  end

  test "user1 shouldn't have email" do
    assert !@user1.has_email?, "should not have email"
  end

  test "create address for user without default address" do
    address = Address.new
    address.user_id = @user2.id
    address.to = "new@somewhere.com"
    assert !@user2.has_email?, "should not have an email address"
    assert address.save!, "should save new address"
    assert User.find_by_id(2).has_email?, "should have an email address"
  end

  test "update and address" do
    address = Address.find_by_user_id(1)
    assert address.to == "real@domain.com", "should have initial value"
    address.to = "changed@domain.com"
    assert address.save!, "should save address"
    assert address.to == "changed@domain.com", "should have changed address"
  end
end
