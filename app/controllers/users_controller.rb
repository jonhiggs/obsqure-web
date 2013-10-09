class UsersController < ApplicationController
  before_filter :authenticate_user!
  def account
    @page = %w[ Account ]
    @user = current_user

    if @user.account_type == 0
      @account_type = "Free"
    else
      @account_type = "Basic"
    end
  end
end
