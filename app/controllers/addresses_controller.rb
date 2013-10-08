class AddressesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
    @user=current_user
    @address = Address.new
    user_guide
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?
    address = Address.new
    address.user_id = current_user.id
    address.to = params["address"]["to"]
    address.save!

    redirect_to :controller => 'addresses', :action => 'index'
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?

    current_user.address(params[:id]).destroy
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def verify
    token = params[:token]
    address = Address.find_by_token(token)

    if address.nil?
      flash[:notice] = "Your address was not found."
    else
      address.verify
      address.save!
      flash[:notice] = "Your address '#{address.to}' is now verified"
    end
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def show
    @address = current_user.address(params[:id])
  end

  def edit
    @address = current_user.address(params[:id])
  end

  def update
    address = current_user.address(params[:id])
    address.to = params[:address][:to]
    if address.save!
      flash[:notice] = "Address was updated."
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
