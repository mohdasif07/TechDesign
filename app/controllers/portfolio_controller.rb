class PortfolioController < ApplicationController
  def index
    @items = PortfolioItem.all
    @category = params[:category].presence_in(%w[all tech interior]) || "all"
    @filtered_items = PortfolioItem.by_category(@category)
  end
end
