module ApplicationHelper
  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : "Arqvexa | Interior Design & Technology"
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : "Arqvexa combines interior design and technology to create modern, functional and innovative spaces for homes and businesses across Delhi NCR and India."
  end

  def meta_keywords
    content_for?(:meta_keywords) ? content_for(:meta_keywords) : "interior design Delhi NCR, web development Delhi, IT company Gurgaon, website design, modular kitchen, mobile app development"
  end

  def og_title
    content_for?(:og_title) ? content_for(:og_title) : meta_title
  end

  def og_description
    content_for?(:og_description) ? content_for(:og_description) : meta_description
  end

  def primary_host
    ENV.fetch("APP_HOST", "arqvexa.in")
  end

  def site_url(path = "/")
    path = "/#{path.delete_prefix("/")}" unless path == "/"
    "https://#{primary_host}#{path}"
  end

  def og_image_url
    site_url("/brand/logo-cover-1200x628.png")
  end

  def canonical_url
    raw = content_for?(:canonical_url) ? content_for(:canonical_url) : site_url(canonical_path)
    normalize_canonical_url(raw)
  end

  def canonical_path
    path = request.path.to_s
    path = "/" if path.blank?
    path
  end

  def normalize_canonical_url(url)
    uri = URI.parse(url.to_s)
    uri.fragment = nil
    uri.query = nil
    normalized_path = uri.path.presence || "/"
    normalized_path = "/" if normalized_path.blank?
    uri.path = normalized_path
    uri.to_s
  rescue URI::InvalidURIError
    site_url("/")
  end

  def home_page?
    controller_name == "home" && action_name == "index"
  end

  def nav_link(path, label, anchor: nil, extra_class: nil)
    href = if anchor
      home_page? ? anchor : "#{root_path}#{anchor}"
    else
      path
    end

    classes = [extra_class, ("is-active" if current_page?(path))].compact.join(" ")
    opts = {}
    opts[:class] = classes if classes.present?
    opts[:data] = { nav_link: true } if home_page? && anchor

    link_to label, href, opts
  end

  def contact_email
    ENV.fetch("CONTACT_EMAIL", "hello@arqvexa.in")
  end

  def contact_email_internal
    ENV.fetch("CONTACT_EMAIL_INTERNAL", "mohdasif.dev01@gmail.com")
  end

  def contact_form_path
    if (controller_name == "home" && action_name == "index") ||
       (controller_name == "pages" && action_name.in?(%w[interior_design it_development contact])) ||
       controller_name == "services"
      "#contact"
    else
      contact_page_path(anchor: "contact")
    end
  end

  def contact_email_link(**options)
    link_to contact_email, contact_form_path, options.reverse_merge(class: "contact-email-link")
  end

  def contact_phone_display
    "+91 99176 39330"
  end

  def contact_phone_tel
    "+919917639330"
  end

  def service_page_icon(slug, division)
    icons = if division == "interior"
      {
        "residential-interior-design" => "⌂",
        "modular-kitchen" => "◫",
        "office-interior-design" => "▣",
        "commercial-interior-design" => "◆",
        "3d-visualization" => "◉",
        "wardrobes-storage" => "▤"
      }
    else
      {
        "web-development" => "</>",
        "ecommerce-development" => "🛒",
        "mobile-app-development" => "📱",
        "ai-development" => "✦",
        "crm-development" => "📊",
        "custom-software-development" => "⚙",
        "api-development" => "⇄"
      }
    end
    icons.fetch(slug, division == "interior" ? "⌂" : "</>")
  end
end
