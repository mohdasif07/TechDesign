class PagesController < ApplicationController
  def interior_design
    @interior_services = ServicePage.for_division(:interior)
  end

  def it_development
    @it_services = ServicePage.for_division(:it)
  end

  def about
  end

  def contact
  end

  def privacy
  end
end
