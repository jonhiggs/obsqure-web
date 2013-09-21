require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "test a user" do
    user = User.find_by_email("addr1@domain.com")
    assert user.id == 1
  end

end
