News::Application.routes.draw do
  get "sessions/create"

  get "sessions/destroy"

  get "session/create"

  get "session/destroy"

  resources :cats
  match '/images/new/(:id)' => 'images#new', :as => 'image_new'
  resources :images

  resources :entries do
    resources :images
  end
  resources :sessions

  root :to => 'entries#index'

  match '/login', :controller => 'sessions', :action => 'new'
  match '/logout', :controller => 'sessions', :action => 'destroy'
  match '/news', :controller => 'entries', :action => 'index'
  match '/news/:id/:name', :controller => 'entries', :action => 'index'

  match '/update_main', :controller => 'entries', :action => 'update_main'

  #match '/images/new?entrie_id=:id' => 'images#new:id', :id => :id #, :as => 'images#new'
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
