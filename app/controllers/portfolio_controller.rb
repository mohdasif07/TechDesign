class PortfolioController < ApplicationController
  def index
    @items = PortfolioItem.all
    @category = params[:category].presence_in(%w[all tech interior]) || "all"
    @filtered_items = PortfolioItem.by_category(@category)
  end

  def show
    @item = PortfolioItem.find!(params[:id])
    @breadcrumb_items = [
      { label: "Home", url: site_url },
      { label: "Portfolio", url: site_url(portfolio_path) },
      { label: @item.title, url: site_url(@item.path) }
    ]
  rescue PortfolioItem::NotFound
    raise ActionController::RoutingError, "Not Found"
  end
end
