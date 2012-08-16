RoutingWorkshop::Application.routes.draw do
  resources :things do
    collection do
      get :yay
    end
    member do
      get :nay
    end
  end

  scope :path => '/wings', :controller => 'wings' do
    scope :as => 'wings' do
      match :action => :index, :via => :get
      match :action => :create, :via => :post
      match :as => 'yay', :path => 'yay', :action => :yay, :via => :get
    end
    scope :as => 'wing' do
      match :as => 'new', :path => 'new', :action => :new, :via => :get
      scope :path => ':id' do
        match :as => 'edit', :path => 'edit', :action => :edit, :via => :get
        match :action => :show, :via => :get
        match :action => :update, :via => :put
        match :action => :destroy, :via => :delete
        match :as => 'nay', :path => 'nay', :action => :nay, :via => :get
      end
    end
  end
end
