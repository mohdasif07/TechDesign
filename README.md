# AS DesignTech — Rails Website

Rails implementation of the AS DesignTech landing page, keeping the same visual direction as the static version.

## Run

```bash
bundle install
bin/rails server
```

Open http://localhost:3000

## Customize before launch

- Replace the placeholder WhatsApp number in `app/views/home/index.html.erb`.
- Replace `hello@asdesigntech.in` with your real business email.
- Replace concept portfolio cards with real projects.
- Add your real phone/social links.
- For production, configure a real domain, SSL, email delivery and analytics.

## Rails structure

- `HomeController#index` renders the homepage.
- `app/views/home/index.html.erb` contains the page.
- `app/assets/stylesheets/application.css` contains the responsive design.
- `app/javascript/application.js` controls the mobile navigation.
