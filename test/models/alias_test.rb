require 'test_helper'

class AliasTest < ActiveSupport::TestCase
  setup do
    @user1 = User.find_by_id(1)
    @user3 = User.find_by_id(3)
  end

  test "should create new alias" do
    a = Alias.new
    a.address_id = @user1.addresses.first.id
    a.name = "new alias"
    assert a.save!, "should save alias"
    assert !a.to.match(/[A-Z0-9]{6}@obsqure.me/).nil?, "should have valid address"
  end

  test "should show if alias is verified" do
    address = @user3.verified_addresses.first
    alias1 = address.aliases.first
    assert alias1.verified?
    address.verified = false
    assert address.save!, "should save address as unverified"
    assert !alias1.verified?
  end
end
