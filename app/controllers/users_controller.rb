class UsersController < ApplicationController
  def account
    redirect_to("/users/sign_in") unless user_signed_in?
    @user = current_user

    if @user.account_type == 0
      @account_type = "Free"
    else
      @account_type = "Basic"
    end
  end
end
