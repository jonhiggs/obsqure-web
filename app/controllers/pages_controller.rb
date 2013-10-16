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
end
