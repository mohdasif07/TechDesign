class LocationsController < ApplicationController
  def interior
    @location = LocationPage.find!("interior", params[:city])
    render :show
  rescue LocationPage::NotFound
    raise ActionController::RoutingError, "Not Found"
  end

  def web
    @location = LocationPage.find!("web", params[:city])
    render :show
  rescue LocationPage::NotFound
    raise ActionController::RoutingError, "Not Found"
  end
end
