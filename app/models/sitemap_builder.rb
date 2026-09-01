class SitemapBuilder
  class << self
    def urls
      static_pages + service_pages + portfolio_pages + blog_pages
    end

    private

    def static_pages
      [
        entry("/", changefreq: "weekly", priority: "1.0", lastmod: today),
        entry("/about", changefreq: "monthly", priority: "0.8", lastmod: today),
        entry("/contact", changefreq: "monthly", priority: "0.85", lastmod: today),
        entry("/interior-design", changefreq: "weekly", priority: "0.9", lastmod: today),
        entry("/it-development", changefreq: "weekly", priority: "0.9", lastmod: today),
        entry("/portfolio", changefreq: "weekly", priority: "0.85", lastmod: today),
        entry("/blog", changefreq: "weekly", priority: "0.85", lastmod: today),
        entry("/privacy", changefreq: "yearly", priority: "0.4", lastmod: "2026-08-30")
      ]
    end

    def service_pages
      ServicePage.all.map do |page|
        entry(page.path, changefreq: "monthly", priority: "0.85", lastmod: today)
      end
    end

    def portfolio_pages
      PortfolioItem.all.map do |item|
        entry("/portfolio/#{item.id}", changefreq: "monthly", priority: "0.75", lastmod: today)
      end
    end

    def blog_pages
      BlogPost.all.map do |post|
        entry("/blog/#{post.slug}", changefreq: "monthly", priority: "0.8", lastmod: post.published_at)
      end
    end

    def entry(path, changefreq:, priority:, lastmod:)
      { loc: "#{base_url}#{path}", changefreq: changefreq, priority: priority, lastmod: lastmod }
    end

    def base_url
      "https://#{ENV.fetch("APP_HOST", "arqvexa.in")}"
    end

    def today
      Date.current.iso8601
    end
  end
end
