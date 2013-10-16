class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    if user.verified_addresses.empty?
      :addresses
    else
      :aliases
    end
  end

  def user_guide
    return true if current_user.guide_complete

    if current_user.addresses.count == 0
      flash[:guide] = "Next Step: Add an email address."
    elsif current_user.verified_addresses.count == 0 
      flash[:guide] = "Next Step: Verify your email address."
    elsif current_user.aliases.count == 0
      flash[:guide] = "Next Step: Create an alias."
    end

    if flash[:guide].nil?
      flash[:guide] = "Congratulations, your account is all set up."
      current_user.guide_complete = true
      current_user.save!
    end
  end
end
