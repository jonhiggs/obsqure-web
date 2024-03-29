class AliasesController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!
  before_filter :mine?

  def index
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

    a.save
    unless flash_messages(a)[:error].empty?
      redirect_to :controller => 'aliases', :action => 'edit', :id => params[:alias][:id]
    else
      redirect_to :controller => 'aliases'
    end
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

  def mine?
    return true if params[:id].nil?

    if current_user.alias(params[:id]).nil?
      flash_messages ["Hey! That's not yours."]
      redirect_to :controller => 'aliases'
    end
  end
end
