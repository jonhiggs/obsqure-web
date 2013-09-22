require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user1 = User.find_by_id(1)
    @user2 = User.find_by_id(2)
    @user3 = User.find_by_id(3)
  end

  test "email_required? false for devise" do
    assert !@user1.email_required?
  end

  test "for an id" do
    assert @user1.id == 1
  end

  test "addresses" do
    assert !@user1.addresses.empty?
    assert @user2.addresses.empty?
  end

  test "address" do
    address_id = @user1.addresses.first.id
    assert @user1.address(address_id).id == address_id, "should get address by id"
  end

  test "email" do
    assert @user1.email==0, "user1 should not have an email address"
    assert @user2.email==0, "user2 should not have an email address"
  end

  test "has_email?" do
    assert !@user1.has_email?, "user1 shouldn't have an email address"
    assert @user1.email = @user1.addresses.first.id
    assert @user1.has_email?, "user1 should now have an email address"
  end

  test "default_address" do
    assert @user1.default_address=="", "should start with empty address"
    new_default_address = @user1.addresses.first
    @user1.email = new_default_address.id
    assert @user1.default_address == new_default_address, "should be what we set it."
  end

  test "verified_aliases" do
    assert @user1.verified_aliases.empty?
    assert !@user3.verified_aliases.empty?
  end

  test "has_verified_address" do
    assert @user1.has_verified_address?, "user1 does have verified addresses"
    assert !@user2.has_verified_address?, "user2 does not have verified addresses"
  end

  test "has_aliases" do
    assert !@user1.has_aliases?, "user1 does not have aliases"
    assert !@user2.has_aliases?, "user2 does not have aliases"
    assert @user3.has_aliases?, "user3 does have aliases"
  end

end
