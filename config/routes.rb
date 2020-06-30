Rails.application.routes.draw do
  root to: 'requests#new'

  resources :requests, only: [:new, :create, :show] do
    # This creates a route /requests/:id/download
    # without member would be /requests/download
    member do
      get 'download', to: 'requests#download'
    end
  end
end
