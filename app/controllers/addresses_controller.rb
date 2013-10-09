class AddressesController < ApplicationController
  def index
    @page = "Addresses"
    redirect_to("/users/sign_in") unless user_signed_in?
    @user=current_user
    @address = Address.new
    user_guide
  end

  def create
    redirect_to("/users/sign_in") unless user_signed_in?
    address = Address.new(
      :user_id => current_user.id,
      :to => params["address"]["to"]
    )

    address.save

    if address.save
      flash[:notice] = "The email address '#{address.to}' has been created."
    else
      address.errors[:to].each do |error|
        flash[:error] = error
      end
    end

    redirect_to :controller => 'addresses', :action => 'index'
  end

  def destroy
    redirect_to("/users/sign_in") unless user_signed_in?
    address = current_user.address(params[:id])

    if current_user.address(params[:id]).destroy
      flash[:notice] = "The email address '#{address.to}' has been deleted."
    else
      flash[:error] = "The email address could not be deleted."
    end

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
      flash[:notice] = "Your address '#{address.to}' is now verified."
    end
    redirect_to :controller => 'addresses', :action => 'index'
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

end
