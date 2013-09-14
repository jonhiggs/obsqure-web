class AddressesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @addresses = Address.find_all_by_user_id(current_user.id).sort_by{|a| a.to}
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

    address = Address.find_by_id(params[:id])

    raise "cannot delete addresses that still have aliases" unless Alias.find_by_address_id(params[:id]).nil?
    raise "cannot delete the default address" if address.default?

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
  end

  def default
    # TODO: make this less shit.
    Address.find_all_by_user_id(current_user.id).map do |a|
      a.default = false
      a.save
    end

    new_default = Address.find_by_id(params[:address_id])
    new_default.default = true
    new_default.save
    
    redirect_to :controller => 'addresses', :action => 'index'
  end

end
