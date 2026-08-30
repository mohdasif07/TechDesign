# Arqvexa — Rails Website

Rails website for **Arqvexa** with equal focus on **Interior Design** and **IT Development**, PWA support, and SEO-optimized service pages.

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

## Deploy on Render

**Important:** Render does **not** change the `*.onrender.com` URL when you rename a service in Settings. The subdomain is fixed when the service is **first created**.

| URL | Status |
|-----|--------|
| `https://as-designtech.onrender.com` | Your **current live** URL (works now) |
| `https://arqvexa.onrender.com` | Does **not** exist until you create a **new** service named `arqvexa` |

Target live URL: **https://arqvexa.onrender.com**

### Get `arqvexa.onrender.com` (create new service)

1. [Render Dashboard](https://dashboard.render.com) → **New +** → **Web Service**
2. Connect repo: `mohdasif07/TechDesign` → branch `main`
3. **Name:** `arqvexa` (exactly — not `arqvexaa`)
4. **Runtime:** Docker · **Region:** Singapore · **Plan:** Free
5. **Health check path:** `/up`
6. Copy **all Environment variables** from the old `as-designtech` service:
   - `APP_HOST` = `arqvexa.onrender.com`
   - `RAILS_MASTER_KEY`, `WEB3FORMS_ACCESS_KEY`, `MAILER_FROM`, etc.
7. **Create Web Service** → wait for deploy → open `https://arqvexa.onrender.com`
8. After the new site works, delete the old **as-designtech** service (optional)

Renaming the service in Settings only changes the dashboard label — the URL stays `as-designtech.onrender.com`.

## SEO setup

After deploying to production:

1. Update domain in `public/sitemap.xml` and `public/robots.txt`
2. Submit sitemap in [Google Search Console](https://search.google.com/search-console)
3. Add real project photos and case studies to both service pages
4. Set up Google Business Profile with both service categories

## Contact form email

The contact form sends enquiries to **mohdasif.dev01@gmail.com**.

### Option A — Web3Forms (recommended, free, works on Render)

1. Open [https://web3forms.com](https://web3forms.com)
2. Enter email: `mohdasif.dev01@gmail.com` → Create Access Key
3. Copy the access key
4. Render → **Environment** → add:

| Key | Value |
|-----|--------|
| `WEB3FORMS_ACCESS_KEY` | your access key from web3forms.com |

5. Save → redeploy. Form emails will arrive in Gmail.

### Option B — Gmail SMTP (optional, may fail on Render)

| Key | Value |
|-----|--------|
| `SMTP_ADDRESS` | `smtp.gmail.com` |
| `SMTP_PORT` | `587` |
| `SMTP_USERNAME` | `mohdasif.dev01@gmail.com` |
| `SMTP_PASSWORD` | Gmail App Password (16 chars) |

Local dev without config saves SMTP emails to `tmp/mail/`.

## New pages

| URL | Purpose |
|-----|---------|
| `/portfolio` | Filterable project gallery (Interior / IT) |
| `/blog` | SEO articles — costs, timelines, guides |
| `/#pricing` | Starting price ranges on homepage |

## Optional: Google Analytics

Add to Render Environment:

| Key | Value |
|-----|--------|
| `GOOGLE_ANALYTICS_ID` | Your GA4 ID (e.g. `G-XXXXXXXXXX`) |

## Customize

- WhatsApp: `919917639330` in `app/views/shared/_contact_form.html.erb`
- Email inbox: `CONTACT_EMAIL` env var or `app/mailers/contact_mailer.rb`

## Structure

- `app/views/home/index.html.erb` — balanced homepage
- `app/views/pages/interior_design.html.erb` — interior SEO page
- `app/views/pages/web_development.html.erb` — IT SEO page
- `app/views/shared/` — navigation, footer, contact partials
- `app/assets/stylesheets/application.css` — all styles
