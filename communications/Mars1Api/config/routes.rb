Rails.application.routes.draw do
  devise_for :user
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      devise_for :users, controller: { sessions: 'sessions'}
      patch '/users/update'
      delete 'sessions/:id/sign_out' => 'sessions#destroy'
      get 'import_nasa_data' => 'mars_reports#import_nasa_data'
      get 'index' => 'mars_reports#index'
      get 'update_nasa_data' => 'mars_reports#update_nasa_data'
      patch 'users/update/:id' => 'users#update'
      patch 'users/mc_update/:id' => 'users#mc_update'
      get 'users' => 'users#index'
      get 'users/get_alert' => 'users#get_alert'
      get 'mars_report/show_latest' => 'mars_reports#show_latest'
    end
  end

  namespace :dashboard do
    root 'static_pages#home'
    get 'storm_simulator' => 'static_pages#storm_simulator', as: "storm_simulator"
    get 'weather/index' => 'mars_reports#index', as: "weather_index"
    get 'users/index' => 'users#index', as: "users_index"
    get 'users/:id' => 'users#edit', as: "edit_users"
    get 'users1/:id' => 'users#edit_mission', as: "edit_mission"
    patch 'users/:id' => 'users#update_alert', as: "update_alert"
    patch 'users1/:id' => 'users#update_mission', as: "update_mission"
    get 'sand_storm' => 'users#sand_storm', as: "sand_storm"
    get 'end_storm' => 'users#end_storm', as: "end_storm"
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
