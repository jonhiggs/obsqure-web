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
    a = Alias.first
    address = Address.find_by_id(a.address_id)
    address.verify
    address.save!

    assert a.verified?, "should have verified alias"
    address.unverify
    address.save!
    assert !a.verified?, "should not have verified alias"
  end

  test "alias has constant address" do
    a = Alias.first
    original_address = a.to
    a.name = "changed the name"
    a.save
    assert_equal Alias.find_by_id(a.id).to, original_address
  end
end

# TODO: create a test if aliases' addresses have been verified.
