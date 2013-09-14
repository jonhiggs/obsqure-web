class UsersController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
  end
end
