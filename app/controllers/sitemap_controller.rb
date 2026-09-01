class SitemapController < ApplicationController
  def index
    @urls = SitemapBuilder.urls
    render layout: false, formats: [:xml]
  end
end
