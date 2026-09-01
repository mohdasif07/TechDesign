class ServicesController < ApplicationController
  def interior
    @service = ServicePage.find!("interior", params[:slug])
  rescue ServicePage::NotFound
    raise ActionController::RoutingError, "Not Found"
  end

  def it
    @service = ServicePage.find!("it", params[:slug])
  rescue ServicePage::NotFound
    raise ActionController::RoutingError, "Not Found"
  end
end
