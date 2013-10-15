class AddressesController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!
  before_filter :mine?

  def index
    @page = "Addresses"
    @user=current_user
    @address = Address.new
    user_guide
  end

  def create
    address = Address.new(
      :user_id => current_user.id,
      :to => params["address"]["to"]
    )
    address.save
    flash_messages(address)
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def destroy
    address = current_user.address(params[:id])
    current_user.address(params[:id]).destroy
    flash_messages(address)
    redirect_to :controller => 'addresses', :action => 'index'
  end

  def verify
    token = params[:token]
    @address = Address.find_by_token(token)

    unless @address.nil?
      @address.verify
      @address.save!
    end
  end

  def show
    @address = current_user.address(params[:id])
  end

  def edit
    @page = %w[ Addresses Edit ]
    @address = current_user.address(params[:id])
  end

  def update
    address = current_user.address(params[:id])
    address.to = params[:address][:to]
    if address.save
      flash[:notice] = "The email address was updated."
      redirect_to :controller => 'addresses'
    else
      flash[:error] = "The email address was invalid."
      redirect_to :controller => 'addresses', :action => "edit", :id => params[:id]
    end
  end

  def default
    current_user.email = current_user.address(params[:address_id]).to
    current_user.save!
    redirect_to :controller => 'addresses', :action => 'index'
  end

protected
  def mine?
    return true if params[:id].nil?

    if current_user.address(params[:id]).nil?
      flash[:error] = "Hey! That's not yours."
      redirect_to :controller => 'addresses'
    end
  end

end
