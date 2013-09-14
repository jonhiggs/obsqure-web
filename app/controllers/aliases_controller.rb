class AliasesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    user = User.find_by_id(current_user.id)
    @alias = Alias.new
    @aliases = user.aliases
    @addresses = user.addresses
  end

  def edit
    @alias = Alias.find_by_id(params[:id])
    redirect_to("/") unless current_user.id == params[:user_id].to_i
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?

    Alias.destroy(params[:id])
    redirect_to :controller => 'users', :action => 'index'
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?

    @alias = Alias.new
    @address = Address.find_by_id(params["address"]["to"])
    @alias.address_id = @address.id
    @alias.save!

    redirect_to :controller => 'addresses', :action => 'index'
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
