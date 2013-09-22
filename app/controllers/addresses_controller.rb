class AddressesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @user=current_user
    @address = Address.new
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?
    address = Address.new
    address.user_id = current_user.id
    address.to = params["address"]["to"]
    address.save!

    if current_user.email.empty?
      current_user.email = address.to
      current_user.save!
    end

    redirect_to :controller => 'addresses', :action => 'index'
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?
    redirect_to("/addresses") unless 

    address = current_user.address(params[:id])
    Address.find_by_id(address.id).destroy
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def verify
    token = params[:token]
    address = Address.find_by_token(token)

    if address.nil?
      redirect_to :controller => 'addresses', :action => 'not_verified'
    elsif address.verified
      flash[:info] = "Your address '#{address.to}' was already verified"
      redirect_to :controller => 'addresses', :action => 'index'
    else
      address.verified = true
      address.save
      flash[:info] = "Your address '#{address.to}' is now verified"
      redirect_to :controller => 'addresses', :action => 'index'
    end
  end

  def not_verified
  end

  def show
    @address = Address.find_by_id(params[:id])
    redirect_to("/") unless @address.user_id.to_i == params[:user_id].to_i
  end

  def edit
    @address = current_user.address(params[:id])
  end

  def update
    address = Address.find_by_id(params[:id])
    address.to = params[:address][:to]
    address.verified = false
    if address.save
      flash[:info] = "Address was updated."
    else
      flash[:error] = "Couldn't update the address."
    end

    redirect_to :controller => 'addresses'
  end

  def default
    current_user.email = current_user.address(params[:address_id]).to
    current_user.save!
    redirect_to :controller => 'addresses', :action => 'index'
  end

end
