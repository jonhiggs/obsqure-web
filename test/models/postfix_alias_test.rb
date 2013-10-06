require 'test_helper'

class PostfixAliasTest < ActiveSupport::TestCase
  test "verify and unverify addresses" do
    a = Alias.first
    address = Address.find_by_id(a.address_id)

    address.verify
    address.save!
    assert PostfixAlias.find_by_from(a.to), "should find an alias for verified address"

    address.unverify
    address.save!
    assert !PostfixAlias.find_by_from(a.to), "should not find alias for unverified address"

    address.verify
    address.save!
    assert PostfixAlias.find_by_from(a.to), "should double-check"
  end

  test "delete alias after address is burnt" do
    address = Address.first
    address.verify!
    a = Alias.new(:address_id => address.id, :name => "burner")
    a.save!
    assert PostfixAlias.find_by_from(a.to), "should find alias for new address"
    a.burn!
    assert !PostfixAlias.find_by_from(a.to), "should not find alias for new address"
  end
end
