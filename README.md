# Arqvexa — Rails Website

Rails website for **Arqvexa** with equal focus on **Interior Design** and **IT Development**, PWA support, and SEO-optimized service pages.

**Live site:** https://arqvexa.in

## Run locally

```bash
bundle install
bin/rails server
```

Open http://localhost:3000

## Pages

| URL | Purpose |
|-----|---------|
| `/` | Homepage — services, portfolio, pricing, blog preview, contact |
| `/interior-design` | Interior design SEO landing page (Delhi NCR) |
| `/web-development` | IT development SEO landing page (India + remote) |
| `/portfolio` | Filterable project gallery |
| `/blog` | SEO articles — costs, timelines, guides |
| `/privacy` | Privacy Policy |
| `/#pricing` | Starting price ranges on homepage |

## Deploy on Render

Service name: **arqvexa** → https://arqvexa.in (Render: `arqvexa.onrender.com` redirects here)

Required environment variables:

| Key | Value |
|-----|--------|
| `RAILS_MASTER_KEY` | From `config/master.key` |
| `APP_HOST` | `arqvexa.in` |
| `WEB3FORMS_ACCESS_KEY` | From [web3forms.com](https://web3forms.com) |
| `MAILER_FROM` | `Arqvexa <mohdasif.dev01@gmail.com>` |
| `CONTACT_EMAIL` | `mohdasif.dev01@gmail.com` |
| `GOOGLE_ANALYTICS_ID` | Optional — GA4 measurement ID |

Push to `main` triggers auto-deploy when connected to Render.

## SEO & Google Business Profile

1. **Search Console** — add property https://arqvexa.in and submit `public/sitemap.xml`
2. **Google Business Profile** — [business.google.com](https://business.google.com):
   - Business name: **Arqvexa**
   - Categories: *Interior designer* + *Software company* (or *Website designer*)
   - Service area: Delhi NCR (Delhi, Gurgaon, Noida)
   - Phone: +91 99176 39330
   - Website: https://arqvexa.in
   - Add photos of interior and IT work when available
3. Custom domain DNS: A `@` → `216.24.57.1`, CNAME `www` → `arqvexa.onrender.com`

## Contact form email

Enquiries go to **mohdasif.dev01@gmail.com** via Web3Forms (browser-side).

1. Open [https://web3forms.com](https://web3forms.com)
2. Enter email → Create Access Key
3. Render → **Environment** → `WEB3FORMS_ACCESS_KEY`

Local dev without SMTP saves emails to `tmp/mail/`.

## Customize content

| What | Where |
|------|--------|
| Portfolio projects | `config/portfolio.yml` |
| Blog articles | `config/blog_posts.yml` |
| Pricing | `app/views/shared/_pricing_section.html.erb` |
| Phone / email helpers | `app/helpers/application_helper.rb` |

## Structure

- `app/views/home/index.html.erb` — homepage
- `app/views/pages/` — service pages + privacy
- `app/views/shared/` — navigation, footer, contact, portfolio, pricing
- `app/assets/stylesheets/application.css` — all styles
