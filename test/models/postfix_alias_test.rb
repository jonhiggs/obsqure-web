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

  test "invalidating address" do
    address = Address.first
    a = Alias.new
    a.address_id = address.id
    a.name = "new alias"
    a.save!
    assert PostfixAlias.find_by_from(a.to), "should first exist in postfix_alias"
    address.verified = false
    assert address.save!, "should unverify the alias"
    assert !PostfixAlias.find_by_from(a.to), "should no longer exist in postfix_alias"
  end
end
