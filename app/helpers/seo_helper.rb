module SeoHelper
  def seo_page(title:, description:, canonical:, keywords: nil, og_image: nil, robots: nil)
    content_for :meta_title, title
    content_for :meta_description, description
    content_for :canonical_url, canonical
    content_for :meta_keywords, keywords if keywords.present?
    content_for :og_image, og_image if og_image.present?
    content_for :robots, robots if robots.present?
  end

  def page_og_image
    content_for?(:og_image) ? content_for(:og_image) : og_image_url
  end

  def robots_meta_content
    content_for?(:robots) ? content_for(:robots) : "index, follow"
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

  def json_ld_script(data)
    payload = data.is_a?(String) ? data : data.to_json
    tag.script(payload.html_safe, type: "application/ld+json")
  end

  def breadcrumb_schema(items = nil)
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
    }
  end

  def service_schema(service)
    {
      "@context" => "https://schema.org",
      "@type" => "Service",
      "name" => service.title,
      "description" => service.meta_description,
      "url" => site_url(service.path),
      "provider" => schema_organization_ref,
      "areaServed" => service.interior? ? "Delhi NCR" : "India"
    }
  end

  def faq_page_schema(faqs)
    {
      "@context" => "https://schema.org",
      "@type" => "FAQPage",
      "mainEntity" => faqs.map do |faq|
        {
          "@type" => "Question",
          "name" => faq["question"],
          "acceptedAnswer" => {
            "@type" => "Answer",
            "text" => strip_tags(faq["answer"].to_s)
          }
        }
      end
    }
  end

  def portfolio_page_schema(item)
    graph = [portfolio_creative_work_schema(item)]
    graph << portfolio_image_gallery_schema(item) if item.has_gallery?
    { "@context" => "https://schema.org", "@graph" => graph }
  end

  def blog_post_schema(post)
    {
      "@context" => "https://schema.org",
      "@type" => "BlogPosting",
      "headline" => post.title,
      "description" => post.excerpt,
      "datePublished" => post.published_at,
      "dateModified" => post.published_at,
      "author" => schema_organization_ref,
      "publisher" => {
        "@type" => "Organization",
        "name" => "Arqvexa",
        "logo" => {
          "@type" => "ImageObject",
          "url" => site_url("/icon.png")
        }
      },
      "mainEntityOfPage" => {
        "@type" => "WebPage",
        "@id" => site_url(blog_post_path(post.slug))
      },
      "image" => og_image_url,
      "url" => site_url(blog_post_path(post.slug))
    }
  end

  private

  def normalize_breadcrumb_items(items)
    case items
    when Array then items
    else []
    end
  end

  def schema_organization_ref
    {
      "@type" => "Organization",
      "name" => "Arqvexa",
      "url" => site_url
    }
  end

  def portfolio_creative_work_schema(item)
    schema = {
      "@type" => "CreativeWork",
      "name" => item.title,
      "description" => item.case_study_summary.presence || item.description,
      "url" => site_url(item.path),
      "creator" => schema_organization_ref,
      "about" => item.category_label
    }
    if item.cover_image.present?
      schema["image"] = site_url(portfolio_image_file(item.cover_image, format: "jpg"))
    end
    schema
  end

  def portfolio_image_gallery_schema(item)
    {
      "@type" => "ImageGallery",
      "name" => item.title,
      "description" => item.case_study_summary.presence || item.description,
      "url" => site_url(item.path),
      "image" => item.gallery.map do |slide|
        {
          "@type" => "ImageObject",
          "contentUrl" => site_url(portfolio_image_file(slide["image"], format: "jpg")),
          "caption" => slide["caption"],
          "description" => slide["alt"]
        }
      end
    }
  end
end
