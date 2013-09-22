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

  test "verified?" do
    address = @user3.addresses.first
    address.verify
    assert address.save!, "should save with verify set to true"
    alias1 = address.aliases.first
    assert alias1.verified?, "should have verified alias"
    address.unverify
    assert address.save!, "should save address as unverified"
    assert !alias1.verified?
  end
end
