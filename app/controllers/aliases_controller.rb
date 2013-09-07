class AliasesController < ApplicationController
  def index
    redirect_to("/users/sign_in") unless user_signed_in?
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
