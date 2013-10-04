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
    address = Address.new(:user_id => @frank.id, :to => "frank2@domain.com")
    assert !address.verified?, "should not have verified address"
    address.verify
    assert address.verified?, "should have verified address"
    address.unverify
    assert !address.verified?, "should not have verified address"
    address.verify
    assert address.verified?, "should have verified address"
    address.save
    assert address.errors.empty?, "should not have any errors"
  end

  test "dont save too many addresses for free users" do
    result = %w[ 1 2 3 4 5 ].map{|a| Address.new(:user_id => @craig.id, :to => "#{a}@d.com").save}
    assert_equal [ true, false, false, false, false ], result
  end
end
