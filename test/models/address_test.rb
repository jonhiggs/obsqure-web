require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  setup do
    @frank = User.find_by_username("frank")
    @craig = User.new(:username => "craig", :password => "bahesfse")
    @craig.save!
  end

  test "has_email" do
    assert @frank.has_email?, "should have email"
    assert !@craig.has_email?, "should not have email"
  end

  test "update and address" do
    address = @frank.address(4564)

    assert !address.verified?, "address should start off unverified"
    assert address.token.length == 32, "should have a token"
    assert address.verify, "should verify address"
    assert address.save, "should save verified address"
    assert address.verified?, "should have verified address"
    assert_equal address.token, "verified"

    assert_equal "frank@somewhere.com", address.to
    address.to = "changed@domain.com"
    assert address.save, "should save address"
    assert_equal "changed@domain.com", address.to
    assert !address.verified?, "address should become unverified after updated"
    assert !address.token.nil?, "should not have a nil token"
  end

  test "token should not change once it's created" do
    assert Address.find_by_id(4564).token != Address.find_by_id(4564).token 
    address = Address.find_by_id(4564)
    address.verify
    address.save!
    original_token = address.token
    address.save!

    assert_equal address.token, original_token
    assert_equal Address.find_by_id(4564).token, original_token
    
    assert_equal Address.find_by_id(4564).token, Address.find_by_id(4564).token 
  end

  test "verifing an address" do
    @craig.addresses.each { |address| address.destroy! }
    @craig.save!
    assert @craig.addresses.empty?, "should not have any addresses"
    assert !@craig.has_maximum_addresses?, "should not have maximum addresses"
    address = Address.new(:user_id => @craig.id, :to => "frank2@domain.com")
    assert !address.verified?, "should not have verified address"
    address.verify
    assert address.verified?, "should have verified address"
    address.unverify
    assert !address.verified?, "should not have verified address"
    address.verify
    assert address.verified?, "should have verified address"
    address.save
    assert address.verified?, "should remain verifyed after saving"
    assert address.errors.empty?, "should not have any errors"
    assert address.save!, "should save address"
    assert Address.find_by_id(address.id).verified?, "should have saved that we are verified"
  end

  test "dont save too many addresses for free users" do
    user = User.new(:username => "bruce", :password => "aoijfseoifj")
    user.account_type = 0
    user.save!
    assert_equal "1", user.maximum_addresses.to_s
    assert_equal 0, user.used_addresses
    result = %w[ 1 2 3 4 5 6 7 ].map {|a| Address.new(:user_id => user.id, :to => "#{a}@d.com").save}
    assert user.has_maximum_addresses?, "should now have maximum addresses"
    assert_equal [ true, false, false, false, false, false, false ], result
  end

  test "don't create an address for an unknown user" do
    address = Address.new(:user_id => 345543, :to => "user@blah.com")
    address.save
    assert_equal ["user does not exist"], address.errors[:user_id]
  end

  test "don't delete an address that has aliases" do
    a = Alias.first
    address = Address.find_by_id(a.address_id)
    user = User.find_by_id(address.user_id)
    address.destroy
    assert_equal ["You cannot delete addresses that still have aliases."], address.errors[:user_id]
  end

  test "deleting an default address should delete the reference from a user" do
    address = Address.first
    user = User.find_by_id(address.user_id)

    user.address_id = address.id
    assert user.save, "should save new default email address"

    # delete the aliases that the address has
    user.aliases.each { |a| a.destroy! if a.address_id == address.id }
    assert_equal 0, user.aliases.count

    assert address.destroy!, "should destroy the address"
    assert User.find_by_id(address.user_id).address_id.nil?, "should remove address_id from owner"
  end

  test "address with an obsqure.me domain" do
    user = User.first
    user.account_type = 2
    user.save!

    address = Address.new(:user_id => user.id, :to => "whatever@obsqure.me" )
    assert !user.has_maximum_addresses?
    assert !address.save
    assert_equal ["The address has a disallowed domain."], address.errors[:to]
  end

  test "delete an unverified address" do
    steven = User.new(:username => "steven", :password => "soijefeosj")
    steven.save
    address = Address.new(:user_id => steven.id, :to => "steven@ljseoij.com")
    address.save!
    assert address.destroy, "should delete an unverified address"
  end

  test "verify link works" do
    address = Address.first
    address.unverify
    address.token = "abcdefg"
    assert_match "http://www.obsqure.net/verify/abcdefg", address.verify_link
    address.verify
    assert_match "http://www.obsqure.net/verify", address.verify_link
  end
end
