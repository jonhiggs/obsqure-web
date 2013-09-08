class UsersController < ApplicationController
  def index
    #@aliases = Alias.find_all_by_user_id(1).address
    @aliases = Alias.find(:all, "user_id")
  end

end
