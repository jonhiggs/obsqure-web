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
    assert lucy.save
    assert lucy.addresses.empty?, "should have no addresses"
    assert !User.find_by_username("lucy").has_email?, "should not have a default email address."

    lucyatdomain = Address.new(
      :user_id => lucy.id,
      :to => "lucy@domain.com"
    )
    assert lucyatdomain.save
    assert lucy.addresses.any?, "should have an address"

    lucy = User.find_by_username("lucy")   # reload the lucy User object.
    assert lucy.has_email?, "should have a default email address."
    assert_equal "lucy@domain.com", lucy.email
  end

  test "aliases" do
    wally = User.new(:username => "wally", :password => "abcdefg")
    assert wally.save
    main_address = Address.new(:user_id => wally.id, :to => "wally@domain.com")
    assert main_address.save
    facebook_alias = Alias.new(:address_id => main_address.id, :name => "facebook")

    assert !facebook_alias.save, "cannot save alias to unverified address"
    assert wally.verified_aliases.empty?
    assert !wally.has_verified_address?, "should not have verified address"
    assert !wally.has_aliases?, "should not have aliases"
    assert main_address.verify, "verify main_address"
    assert main_address.save
    assert facebook_alias.save, "should save alias to verified address"

    wally = User.find_by_username("wally")   # reload the wally User object.
    assert wally.has_verified_address?, "should have verified address"
    assert wally.verified_aliases.any?
    assert wally.has_aliases?, "should have aliases"
  end

  test "deleted account gets completly cleaned up" do
    assert @user3.has_addresses?, "should have addresses"
    assert @user3.has_aliases?, "should have aliases"
    # delete the user
    # assert postfix_aliases are deleted
    # assert addresses are deleted
  end

end
