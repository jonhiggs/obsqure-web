class UsersController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @user = User.find_by_id(current_user.id)
    @aliases = Alias.find(:all, "user_id")
  end

end
