class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  def destroy
    raise "not for you" unless params[:user][:password] == "secret"
    super
  end
end 
