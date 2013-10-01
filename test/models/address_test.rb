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
    address = @frank.addresses.first
    facebook_alias = @frank.aliases.first

    assert address.verified?, "address should start off verified"
    assert address.token.nil?, "should have a nil token"
    assert facebook_alias.verified?, "alias should start off verified"
    assert_equal "frank@somewhere.com", address.to
    address.to = "changed@domain.com"
    assert address.save, "should save address"

    assert_equal "changed@domain.com", address.to
    assert !address.verified?, "address should become unverified after updated"
    assert !address.token.nil?, "should not have a nil token"
    assert !facebook_alias.verified?, "alias should become unverified after addresses is updated"
  end

  test "dont save too many addresses for free users" do
    result = %w[ 1 2 3 4 5 ].map{|a| Address.new(:user_id => @craig.id, :to => "#{a}@d.com").save}
    assert_equal [ true, false, false, false, false ], result
  end
end
