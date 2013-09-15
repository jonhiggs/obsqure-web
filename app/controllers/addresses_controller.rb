class AddressesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @addresses = User.find_by_id(current_user.id).addresses
    @address = Address.new
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?
    address = Address.new
    address.user_id = current_user.id
    address.to = params["address"]["to"]
    address.default = !User.find_by_id(current_user).has_default_address?
    address.save!

    redirect_to :controller => 'addresses', :action => 'index'
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?
    redirect_to("/addresses") unless 

    address = Address.find_by_id(params[:id])

    raise "cannot delete addresses that still have aliases" unless Alias.find_by_address_id(params[:id]).nil?

    address.destroy
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
    @address = Address.find_by_id(params[:id])
  end

  def update
    address = Address.find_by_id(params[:id])
    address.to = params[:address][:to]
    if address.save
      flash[:info] = "Address was updated."
    else
      flash[:error] = "Couldn't update the address."
    end

    redirect_to :controller => 'addresses'
  end

  def default
    User.find_by_id(current_user.id).default_address=params[:address_id]
    redirect_to :controller => 'addresses', :action => 'index'
  end

end
