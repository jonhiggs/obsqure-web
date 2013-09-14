class AliasesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    user = User.find_by_id(current_user.id)
    @alias = Alias.new
    @aliases = user.aliases.sort_by{|a| a.name}
    @addresses = user.addresses
  end

  def edit
    @alias = Alias.find_by_id(params[:id])
    @address = Address.find_by_id(@alias.address_id)
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?
    redirect_to("/aliases") unless 

    @alias = Alias.find_by_id(params[:id])
    owner = Address.find_by_id(@alias.address_id).user_id
    redirect_to("/aliases") unless owner == current_user.id

    Alias.destroy(params[:id])
    redirect_to :controller => 'aliases', :action => 'index'
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?

    @alias = Alias.new
    @address = Address.find_by_id(params["address"]["to"])
    @alias.name = params["alias"]["name"]
    @alias.address_id = @address.id
    @alias.save!

    redirect_to :controller => 'aliases', :action => 'index'
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
