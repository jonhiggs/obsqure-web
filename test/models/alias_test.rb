require 'test_helper'

class AliasTest < ActiveSupport::TestCase
  setup do
    @user1 = User.find_by_id(1)
  end

  test "should create new alias" do
    a = Alias.new
    a.address_id = @user1.addresses.first.id
    a.name = "new alias"
    assert a.save!, "should save alias"
    assert !a.to.match(/[A-Z0-9]{6}@obsqure.me/).nil?, "should have valid address"
  end

end
