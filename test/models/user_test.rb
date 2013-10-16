require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @frank = User.find_by_username("frank")
    @jon = User.find_by_username("jon")
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

  test "maximum_addresses" do
    roger = User.new(:username => "roger", :password => "soeijfaofjapruf")
    assert roger.save

    assert roger.addresses.empty?, "should have no addresses"
    assert !roger.has_maximum_addresses?, "should not have maximum addresses"
    address1 = Address.new(:user_id => roger.id, :to => "roger@somewhere.com")
    assert address1.save
    assert !roger.addresses.empty?, "should have an addresses"
    assert roger.has_maximum_addresses?, "should have maximum addresses"
    address2 = Address.new(:user_id => roger.id, :to => "roger2@somewhere.com")
    assert !address2.save
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
    assert lucyatdomain.verify
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

    facebook_alias.save
    assert_equal ["address must be verified"], facebook_alias.errors[:address_id]
    assert wally.verified_aliases.empty?
    assert !wally.has_verified_address?, "should not have verified address"
    assert !wally.has_aliases?, "should not have aliases"
    assert main_address.verify, "verify main_address"
    assert main_address.save
    assert facebook_alias.save, "should save alias to verified address"

    wally = User.find_by_username("wally")   # reload the wally User object.
    assert facebook_alias.errors[:address_id].empty?, "should have no errors"
    assert wally.has_verified_address?, "should have verified address"
    assert wally.verified_aliases.any?
    assert wally.has_aliases?, "should have aliases"
  end

  test "deleted account gets completly cleaned up" do
    david = User.new(:username => "david", :password => "lskjoseijf")
    assert david.save!, "should save user"

    davids_address = Address.new(:user_id => david.id, :to => "david@domain.com")
    davids_address.verify
    assert davids_address.save!, "should save address"

    davids_alias = Alias.new(:address_id => davids_address.id, :name => "alias")
    assert davids_alias.save!, "should save alias"

    assert User.find_by_id(david.id), "should find user"
    assert Address.find_by_id(davids_address.id), "should find address"
    assert Alias.find_by_id(davids_alias.id), "should find alias"

    assert_equal 1, david.addresses.count
    assert_equal 1, david.aliases.count

    assert david.destroy!, "should delete frank"
    assert Alias.find_by_id(davids_alias.id).burnt?, "should have burnt the alias"
    assert !Address.find_by_id(davids_address.id), "should not find david's address"
    assert !PostfixAlias.find_by_from(davids_alias.to), "should not have postfix_alias for david's alias"
  end

  test "unverified address cannot be a users address" do
    barry = User.new(:username => "barry", :password => "abceesoifg", :account_type => 2)
    barry.save!
    barrys_address = Address.new(:user_id => barry.id, :to => "barry@test.com")
    barrys_address.save!
    assert User.find_by_id(barry.id).address_id.nil?, "should not have saved address unverified address to barry"
    barrys_address.verify
    barrys_address.save!
    assert_equal User.find_by_id(barry.id).address_id, barrys_address.id
    barrys_other_address = Address.new(:user_id => barry.id, :to => "barry2@test.com")
    barrys_other_address.save!
    assert_equal User.find_by_id(barry.id).address_id, barrys_address.id
  end
end
