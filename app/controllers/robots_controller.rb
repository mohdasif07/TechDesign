class RobotsController < ApplicationController
  def show
    response.headers["Cache-Control"] = "public, max-age=21600, must-revalidate"
    response.headers["Content-Type"] = "text/plain; charset=utf-8"

    # Keep Googlebot rules identical to * so public pages stay allowed
    # and only /up + /rails/ stay blocked (specific UA groups do not inherit *).
    render plain: <<~ROBOTS
      # Arqvexa robots.txt
      User-agent: *
      Allow: /
      Disallow: /up
      Disallow: /rails/

      User-agent: Googlebot
      Allow: /
      Disallow: /up
      Disallow: /rails/

      User-agent: Google-InspectionTool
      Allow: /
      Disallow: /up
      Disallow: /rails/

      Sitemap: https://#{ENV.fetch("APP_HOST", "arqvexa.in")}/sitemap.xml
    ROBOTS
  end
end
