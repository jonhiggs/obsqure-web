module ApplicationHelper
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def flash_messages(obj)
    obj.errors.messages.each do |key|
      key.last.each{|m| flash[:errors] = m}

      #obj.errors.messages[key.to_sym].each do |error|
      #  flash[key.to_sym] = error
      #end
    end
    flash
  end
end

