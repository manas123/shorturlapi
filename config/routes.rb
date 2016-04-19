Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :shorturls do
      	collection do
      		get 'go/:shorturlkey', to: 'shorturls#go', as: :go
    	end
      end
    end
  end

  get 'go/:shorturlkey',  to: 'api/v1/shorturls#go', as: :go
end
