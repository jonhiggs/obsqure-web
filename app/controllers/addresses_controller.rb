class AddressesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @addresses = Address.find_all_by_user_id(current_user.id)
    @address = Address.new
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?
    
    address = Address.new
    address.user_id = current_user.id
    address.to = params["address"]["to"]
    address.default = current_user.addresses.count.zero?
    address.save!

    redirect_to :controller => 'addresses', :action => 'index'
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?
    redirect_to("/addresses") unless 

    raise "cannot delete addresses that still have aliases" unless Alias.find_by_address_id(params[:id]).nil?

    Address.destroy(params[:id])
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def verify
    address = Address.find_by_id(params[:address_id])
    address.verified = true
    address.save
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def show
    @address = Address.find_by_id(params[:id])
    redirect_to("/") unless @address.user_id.to_i == params[:user_id].to_i
  end

  def edit
  end

end
