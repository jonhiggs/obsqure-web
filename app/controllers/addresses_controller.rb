class AddressesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @addresses = Address.find(:all, "user_id")
    @address = Address.new
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?
    
    address = Address.new
    address.address_id = params["address"]["id"]
    address.default = current_user.addresses.count.zero?
    address.save!

    redirect_to :controller => 'addresses', :action => 'index'
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?

    Address.destroy(params[:id])
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def show
    @address = Address.find_by_id(params[:id])
    redirect_to("/") unless @address.user_id.to_i == params[:user_id].to_i
  end

end
