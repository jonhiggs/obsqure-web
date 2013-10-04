require 'test_helper'

class AliasTest < ActiveSupport::TestCase
  setup do
  end

  test "should create new alias" do
    address = Address.first
    address.unverify
    address.save!

    a = Alias.new(:address_id => address.id)

    assert !a.save
    assert_equal ["can't be blank"], a.errors[:name]

    a.name = "alias1"

    assert !a.save
    assert_equal ["address must be verified"], a.errors[:address_id]

    address.verify
    address.save!

    assert a.save
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

  test "create address, create alias, verify address, then destroy alias" do
    address = Address.first
    assert address.unverify, "should unverify address"
    assert address.save!, "should save address"
    a = Alias.new
    a.address_id = address.id
    a.name = "new alias"
    assert a.save!, "should save address"
    assert !a.verified?, "should not be verified"
    assert !PostfixAlias.find_by_from(a.to), "should have postfix_alias"
    assert address.verify, "should verify address"
    assert address.save!, "should save address"
    assert PostfixAlias.find_by_from(a.to), "should have postfix_alias"
    assert a.destroy!, "should destroy alias"
    assert !PostfixAlias.find_by_from(a.to), "should not have postfix_alias"
  end

  test "aliases after changing address" do
    user = User.first
    address = Address.new
    address.user_id = user.id
    address.to = "address_before_changing@address.com"
    address.save!

    assert address.verify!, "should verify address"
    a = Alias.new
    a.address_id = address.id
    a.name = "testing changing addresses"
    assert a.save!, "should save address"

    address.to = "address_after_changing@address.com"
    assert address.save!, "should save changed address"
    assert !address.verified?, "should no longer have verified address"
    assert !PostfixAlias.find_by_from(a.to), "should not have postfix_alias for new address"

    assert address.verify!, "should verify address"
    assert address.verified?, "should have verified address"
    assert a.verified?, "should have verified alias"
    assert PostfixAlias.find_by_from(a.to), "should have postfix_alias for new address"
  end

  test "alias has constant address" do
    address = Address.first
    a = Alias.new
    a.address_id = address.id
    a.name = "new alias"
    assert a.save!, "should save address"
    address = a.address
    a.name = "something else"
    assert a.save!, "should save address again"
    assert address == a.address, "should have same address"
  end
end

# TODO: create a test if aliases' addresses have been verified.
