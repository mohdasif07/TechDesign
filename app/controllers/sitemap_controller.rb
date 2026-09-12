class SitemapController < ApplicationController
  def index
    @urls = SitemapBuilder.urls
    xml = render_to_string(template: "sitemap/index", formats: [:xml], layout: false)

    response.headers["Content-Type"] = "application/xml; charset=utf-8"
    response.headers["Cache-Control"] = "public, max-age=3600, must-revalidate"
    response.headers["Content-Length"] = xml.bytesize.to_s

    # Return empty body on HEAD but keep the real Content-Length so fetchers
    # (including Google) do not treat the sitemap as empty.
    self.status = 200
    self.response_body = request.head? ? [""] : [xml]
  end
end
