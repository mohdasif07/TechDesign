Rails.application.routes.draw do
  root "home#index"

  get "about", to: "pages#about", as: :about
  get "contact", to: "pages#contact", as: :contact_page

  get "interior-design", to: "pages#interior_design", as: :interior_design
  get "interior-design/:slug", to: "services#interior", as: :interior_service

  get "it-development", to: "pages#it_development", as: :it_development
  get "web-development", to: redirect("/it-development", status: 301)

  get "it-development/:slug", to: "services#it", as: :it_service

  get "privacy", to: "pages#privacy", as: :privacy
  get "portfolio", to: "portfolio#index", as: :portfolio
  get "portfolio/:id", to: "portfolio#show", as: :portfolio_item
  get "blog", to: "blog#index", as: :blog
  get "blog/:slug", to: "blog#show", as: :blog_post

  post "contact", to: "contacts#create", as: :contact

  get "sitemap.xml", to: "sitemap#index", as: :sitemap

  get "up" => "rails/health#show", as: :rails_health_check

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
