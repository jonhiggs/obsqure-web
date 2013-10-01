require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @frank = User.find_by_username("frank")
  end

  test "user attributes" do
    bill = User.new

    assert bill.invalid?
    assert bill.errors[:username].any?, "user should be invalid without a username"
    bill.username = "bill"
    assert bill.invalid?
    assert bill.errors[:username].empty?, "user should be valid now"

    assert bill.errors[:password].any?, "user should be invalid without password"
    assert bill.password = "abcdefg"
    assert bill.valid?
    assert bill.errors[:password].empty?, "user should be valid with an password"

    bill.valid?
    assert_equal nil, bill.address_id
    assert bill.errors[:address_id].empty?, "should start with a safe default of nil"
    assert bill.address_id = "words@dont.go.here"
    assert bill.invalid?, "user should be invalid with non-integer email"
  end

  test "email_required? is false for devise" do
    assert !@frank.email_required?
  end

  test "for an id" do
    assert_equal 3462, @frank.id
  end

  test "addresses" do
    lucy = User.new(
      :username => "lucy",
      :password => "abcdefg"
    )
    lucy.save!

    assert lucy.addresses.empty?, "should have no addresses"

    lucyatdomain = Address.new(
      :user_id => lucy.id,
      :to => "lucy@domain.com"
    )
    lucyatdomain.save!

    assert lucy.addresses.any?, "should have an address"
  end

  #test "address" do
  #  address_id = @user1.addresses.first.id
  #  assert @user1.address(address_id).id == address_id, "should get address by id"
  #end

  #test "email" do
  #  assert @user1.email==0, "user1 should not have an email address"
  #  assert @user2.email==0, "user2 should not have an email address"
  #end

  #test "has_email?" do
  #  assert !@user1.has_email?, "user1 shouldn't have an email address"
  #  assert !@user4.has_email?, "user2 should not have an email"
  #  assert @user1.email = @user1.addresses.first.id
  #  assert @user1.has_email?, "user1 should now have an email address"
  #end

  #test "default_address" do
  #  assert @user1.default_address=="", "should start with empty address"
  #  new_default_address = @user1.addresses.first
  #  @user1.email = new_default_address.id
  #  assert @user1.default_address == new_default_address, "should be what we set it."
  #end

  #test "verified_aliases" do
  #  assert @user1.verified_aliases.empty?
  #  assert !@user3.verified_aliases.empty?
  #end

  #test "has_verified_address" do
  #  assert @user1.has_verified_address?, "user1 does have verified addresses"
  #  assert !@user2.has_verified_address?, "user2 does not have verified addresses"
  #end

  #test "has_aliases" do
  #  assert !@user1.has_aliases?, "user1 does not have aliases"
  #  assert !@user2.has_aliases?, "user2 does not have aliases"
  #  assert @user3.has_aliases?, "user3 does have aliases"
  #end

  #test "deleted account gets completly cleaned up" do
  #  assert @user3.has_addresses?, "should have addresses"
  #  assert @user3.has_aliases?, "should have aliases"
  #  # delete the user
  #  # assert postfix_aliases are deleted
  #  # assert addresses are deleted
  #end

end
