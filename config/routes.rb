Rails.application.routes.draw do
  devise_for :users,
             path: "api/v1/auth",
             controllers: {
               sessions: "api/v1/sessions",
               omniauth_callbacks: "api/v1/omniauth_callbacks"
             },
             defaults: { format: :json }

  namespace :api do
    namespace :v1 do
      get "csrf", to: "csrf#show"
      get "me",   to: "users#me"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "frontend#index"

  get "*path",
      to: "frontend#index",
      constraints: ->(r) { r.path !~ /\A\/api\// },
      format: false
end
