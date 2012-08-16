RoutingWorkshop::Application.routes.draw do
  resources :things do
    collection do
      get :yay
    end
    member do
      get :nay
    end
  end

  scope :path => '/pings', :controller => 'pings' do
    scope :as => 'pings' do
      match :action => :create, :via => :post
      with_scope_level(:collection) do
        match :action => :index, :via => :get
        match :as => 'yay', :path => 'yay', :action => 'yay', :via => :get
      end
    end
    scope :as => 'ping' do
      with_scope_level(:new) do
        match :path => 'new', :action => 'new', :via => :get
      end
      scope :path => ':id' do
        with_scope_level(:member) do
          match :as => 'edit', :path => 'edit', :action => :edit, :via => :get
          match :as => 'nay', :path => 'nay', :action => 'nay', :via => :get
          match :action => 'show', :via => :get
          match :action => 'update', :via => :put
          match :action => :destroy, :via => :delete
        end
      end
    end
  end
end
