require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  setup do
    @user1 = User.find_by_id(1)
    @user2 = User.find_by_id(2)
    @user3 = User.find_by_id(3)
    @user4 = User.find_by_id(4)
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

  test "verifed address should become unverifed after changing" do
    # create a verified address
    address = Address.new
    address.user_id = @user1.id
    address.to = "sjfoseijf@blah.com"
    address.unverify
    assert address.save!, "should save new address"
    assert !address.verified?, "should not be verified"

    address.verify
    assert address.save!, "should save new address"
    assert address.verified?, "should be verified"

    address.to = "changed@ojs.com"
    assert address.save!, "should save changed address"
    assert !address.verified?, "should not be verified"
  end

  test "addresses should have aliases" do
    address = Address.find_by_user_id(@user3.id)
    assert address.aliases.count == 1
  end

  test "unverifying an address should unverify it's aliases" do
    address = Address.new
    address.user_id = @user1.id
    address.to = "boisjefo@bsoeifj.com"
    assert address.save!, "should save new address"
    address.verify
    address.save!
    assert !address.token?, "should have an address without a token"

    alias1 = Alias.new
    alias1.address_id = address.id
    alias1.name = "one"
    assert alias1.save!, "should save alias1"
    assert alias1.verified?, "should have verified alias1"

    address.unverify
    assert address.save!, "should save address as unverified"
    assert !address.verified?, "should not have a verified address"
    assert address.token?, "should have an address with a token"
    assert !alias1.verified?, "should not have a verified alias1"
  end

  test "first address" do
    address = Address.new
    address.user_id = @user2.id
    address.to = "brand@spanka.com"
    assert address.save!, "should save new address"
    assert !address.verified?, "should not have verified address"
    assert !address.token.nil?, "should not have a nil token"
    assert address.default?, "should set first address to default"
    assert User.find_by_id(address.user_id).email == address.id, "should have email of new address"
  end

  test "dont save too many addresses for free users" do
    a1 = Address.new
    a1.user_id = @user4.id
    a1.to = "one@lsef.com"
    assert a1.save, "should save first address"

    a2 = Address.new
    a2.user_id = @user4.id
    a2.to = "two@lsef.com"
    assert !a2.save, "should not save second address"
  end

  test "dont save too many addresses for basic users" do
    a1 = Address.new
    a1.user_id = @user1.id
    a1.to = "one@lsef.com"
    assert a1.save, "should save first address"

    a2 = Address.new
    a2.user_id = @user1.id
    a2.to = "two@lsef.com"
    assert a2.save, "should not save second address"
  end
end
