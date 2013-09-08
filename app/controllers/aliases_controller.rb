class AliasesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @aliases = Alias.methods
  end

  def edit
  end

  def destroy
    Alias.destroy(params[:id])
    redirect_to :controller => 'users', :action => 'index'
  end

  def new
    @user = User.find_by_id(current_user.id)
    @user.aliases.create
    redirect_to :controller => 'users', :action => 'index'
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
