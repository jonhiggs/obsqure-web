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
    unless current_user.valid_password?(params[:user][:password])
      flash[:error] = "The password you entered is incorrect."
      redirect_to "/users/edit"
    else
      super
    end
  end
end 
