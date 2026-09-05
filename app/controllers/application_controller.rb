class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern, if: -> { !search_engine_crawler? }

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :redirect_to_primary_host, if: -> { Rails.env.production? }

  private

  def search_engine_crawler?
    request.user_agent.to_s.match?(/Googlebot|Google-InspectionTool|bingbot|Slurp|DuckDuckBot|Baiduspider|YandexBot|Sogou|facebot|ia_archiver|Applebot/i)
  end

  def redirect_to_primary_host
    return if request.path == "/up"

    primary = ENV.fetch("APP_HOST", "arqvexa.in")

    if request.host == "www.#{primary}"
      redirect_to "https://#{primary}#{request.fullpath}", status: :moved_permanently, allow_other_host: true
      return
    end

    return if request.host == primary

    redirect_to "https://#{primary}#{request.fullpath}", status: :moved_permanently, allow_other_host: true
  end
end
