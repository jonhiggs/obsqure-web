require 'test_helper'

class PostfixAliasTest < ActiveSupport::TestCase
  test "create" do
    a = PostfixAlias.new
    a.to = "blah@obsqure.com"
    a.from = "blah@blah.com"
    assert a.save!, "should save"
  end

  test "adding an alias" do
    # should add postfix_alias
    address = Address.first
    a = Alias.new
    a.address_id = address.id
    a.name = "new alias"
    assert a.save!, "should save alias"

    assert PostfixAlias.find_by_from(a.to)
  end

  test "removing alias" do
    address = Address.first
    a = Alias.new
    a.address_id = address.id
    a.name = "new alias"
    a.save!
    assert PostfixAlias.find_by_from(a.to), "should first exist in postfix_alias"
    assert a.destroy!, "should delete the alias"
    assert !PostfixAlias.find_by_from(a.to), "should no longer exist in postfix_alias"
  end

  test "unverifing address" do
    address = Address.first
    a = Alias.new
    a.address_id = address.id
    a.name = "new alias"
    a.save!
    assert PostfixAlias.find_by_from(a.to), "should first exist in postfix_alias"
    address.unverify
    assert address.save!, "should unverify the alias"
    assert !PostfixAlias.find_by_from(a.to), "should no longer exist in postfix_alias"
  end

  test "verifing address" do
    address = Address.first
    address.unverify
    assert address.save!, "should unverify address"

    a = Alias.new
    a.address_id = address.id
    a.name = "new alias"
    assert a.save!, "should save address that is unverified"
    assert !PostfixAlias.find_by_from(a.to), "should not have postfix_alias"

    address.verify
    assert address.save!, "should verify address"
    assert PostfixAlias.find_by_from(a.to), "should have postfix_alias"
  end

  test "clean up old postfix aliases when address becomes unverified" do
    a = Alias.first
    address = Address.find_by_id(a.address_id)
    address.verify
    address.save!
    assert PostfixAlias.find_by_from(a.to), "should have postfix_alias"
    address.unverify
    address.save!
    assert !PostfixAlias.find_by_from(a.to), "should not have postfix_alias"
  end

end
