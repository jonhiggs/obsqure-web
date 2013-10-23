class PagesController < ApplicationController
  def faq
    @page = "FAQ"
  end

  def contact
    @page = "Contact"
  end

  def privacy
    @page = "Privacy"
  end

  def terms
    @page = "Terms Of Service"
  end

  def file_not_found
    @page = "File Not Found"
  end

  def internal_server_error
    @page = "Internal Server Error"
  end

  def access_denied
    @page = "Access Denied"
  end

  def manifesto
    @page = "The Obsqure Manifesto"
  end

  def what_is_obsqure
    @page = "What Is Obsqure"
  end
end
