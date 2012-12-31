Dummy::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Session authentication
  match 'login'  => 'sessions#create',  :via => :post
  match 'logout' => 'sessions#destroy', :via => :post

  # See how all your routes lay out with "rake routes"
end
