# AS DesignTech — Rails Website

Rails website for AS DesignTech with equal focus on **Interior Design** and **IT Development**, PWA support, and SEO-optimized service pages.

## Run

```bash
bundle install
bin/rails server
```

Open http://localhost:3000

## Pages

| URL | Purpose |
|-----|---------|
| `/` | Homepage — balanced hub for both divisions |
| `/interior-design` | Interior design SEO landing page (Delhi NCR) |
| `/web-development` | IT development SEO landing page (India + remote) |

## Features

- **Balanced homepage** — split hero, dual CTAs, 3+3 portfolio, split FAQ
- **Dedicated service pages** — unique titles, meta, H1, content, FAQ schema
- **PWA** — installable app with offline support
- **SEO** — canonical URLs, Open Graph, JSON-LD, sitemap.xml
- **Shared layout** — navigation, footer, contact panel partials

## SEO setup

After deploying to production:

1. Update domain in `public/sitemap.xml` and `public/robots.txt`
2. Submit sitemap in [Google Search Console](https://search.google.com/search-console)
3. Add real project photos and case studies to both service pages
4. Set up Google Business Profile with both service categories

## Customize

- WhatsApp: `919917639330` in `app/views/shared/_contact_panel.html.erb`
- Email: `mohdasif.dev01@gmail.com`
- Replace portfolio placeholders with real projects

## Structure

- `app/views/home/index.html.erb` — balanced homepage
- `app/views/pages/interior_design.html.erb` — interior SEO page
- `app/views/pages/web_development.html.erb` — IT SEO page
- `app/views/shared/` — navigation, footer, contact partials
- `app/assets/stylesheets/application.css` — all styles
