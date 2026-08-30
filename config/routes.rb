Rails.application.routes.draw do
  root "home#index"

  get "interior-design", to: "pages#interior_design", as: :interior_design
  get "web-development", to: "pages#web_development", as: :web_development
  get "privacy", to: "pages#privacy", as: :privacy
  get "portfolio", to: "portfolio#index", as: :portfolio
  get "blog", to: "blog#index", as: :blog
  get "blog/:slug", to: "blog#show", as: :blog_post

  post "contact", to: "contacts#create", as: :contact

  get "up" => "rails/health#show", as: :rails_health_check

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
