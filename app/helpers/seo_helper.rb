module SeoHelper
  def seo_page(title:, description:, canonical:, keywords: nil, og_image: nil)
    content_for :meta_title, title
    content_for :meta_description, description
    content_for :canonical_url, canonical
    content_for :meta_keywords, keywords if keywords.present?
    content_for :og_image, og_image if og_image.present?
  end

  def page_og_image
    content_for?(:og_image) ? content_for(:og_image) : og_image_url
  end

  def breadcrumbs(*crumbs)
    @breadcrumb_items = crumbs.flatten
  end

  def breadcrumb_items
    Array(@breadcrumb_items)
  end

  def render_breadcrumbs
    items = breadcrumb_items
    return if items.empty?

    render partial: "shared/breadcrumbs", locals: { items: items }
  end

  def breadcrumb_json_ld(items = nil)
    list = normalize_breadcrumb_items(items || breadcrumb_items).each_with_index.map do |item, index|
      label, url = item.is_a?(Hash) ? [item[:label], item[:url]] : item
      {
        "@type" => "ListItem",
        "position" => index + 1,
        "name" => label,
        "item" => url
      }
    end

    {
      "@context" => "https://schema.org",
      "@type" => "BreadcrumbList",
      "itemListElement" => list
    }.to_json
  end

  def normalize_breadcrumb_items(items)
    case items
    when Array then items
    else []
    end
  end

  def service_schema_json(service)
    {
      "@context" => "https://schema.org",
      "@type" => "Service",
      "name" => service.title,
      "description" => service.meta_description,
      "url" => site_url(service.path),
      "provider" => {
        "@type" => "Organization",
        "name" => "Arqvexa",
        "url" => site_url
      },
      "areaServed" => service.interior? ? "Delhi NCR" : "India"
    }.to_json
  end
end
