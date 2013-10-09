class AliasesController < ApplicationController
  include ApplicationHelper
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @page = "Aliases"
    @user = current_user
    @alias = Alias.new
    user_guide
  end

  def edit
    @page = %w[ Aliases Edit ]
    @alias = current_user.alias(params[:id])
    @addresses = current_user.verified_addresses
  end

  def burn
    redirect_to("/users/sign_in") unless user_signed_in?
    redirect_to("/aliases") unless 

    a = current_user.alias(params[:id])
    current_user.alias(a.id).burn!
    redirect_to :controller => 'aliases', :action => 'index'
  end

  def create
    a = Alias.new(
      :name => params["alias"]["name"],
      :address_id => params["address"]["to"]
    )
    a.save
    flash_messages(a)
    redirect_to :controller => 'aliases', :action => 'index'
  end

  def update
    a = current_user.alias(params[:alias][:id])
    a.address_id = params[:address][:to]
    a.name = params[:alias][:name]

    if params[:alias][:name].empty?
      flash[:error] = "The alias's name cannot be empty."
      redirect_to :controller => 'aliases', :action => 'edit', :id => params[:alias][:id]
      return true
    end

    a.save
    flash_notices(a)
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
    @address = current_user.address(address_id)
    @alias = Alias.new
    @alias.name = alias_name
    @alias.address_id = @address.id
    @alias.save!
    @alias.to
  end
end
