class AliasesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @user = User.find_by_id(current_user.id)
    @alias = Alias.new
  end

  def edit
    user = User.find_by_id(current_user.id)
    @alias = user.alias(params[:id])
    @addresses = user.verified_addresses
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?
    redirect_to("/aliases") unless 

    user = User.find_by_id(current_user.id)
    a = user.alias(params[:id])

    if a.nil?
      flash[:notice] = "Alias doesn't exist."
    else
      Alias.destroy(a.id)
      flash[:notice] = "Deleted alias '#{a.to}'"
    end
    redirect_to :controller => 'aliases', :action => 'index'
  end

  def create
    if params["alias"]["name"].empty?
      flash[:error] = "You must provide a name for your alias."
      redirect_to :controller => 'aliases'
    else
      address_id = params["address"]["to"]
      name = params["alias"]["name"]
      flash[:notice] = "Created Alias #{self.save_alias(address_id,name)}"
      redirect_to :controller => 'aliases', :action => 'index'
    end
  end

  def update
    a = Alias.find_by_id(params[:alias][:id])
    a.address_id = params[:address][:to]
    a.name = params[:alias][:name]
    if a.save
      flash[:info] = "Address was updated."
    else
      flash[:error] = "Couldn't update the address."
    end

    redirect_to :controller => 'aliases'
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

protected
  def save_alias(address_id,alias_name)
    @address = Address.find_by_id(address_id)
    @alias = Alias.new
    @alias.name = alias_name
    @alias.address_id = @address.id
    @alias.save!
    @alias.to
  end
end
