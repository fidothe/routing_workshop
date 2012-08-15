module RH
  def self.fake_resources(mapper, plural_name)
    singular_name = plural_name.singularize
    mapper.instance_exec do
      scope :path => plural_name, :controller => plural_name do
        scope :as => plural_name do
          with_scope_level(:collection) do
            get :index
            post :create
          end
        end
        scope :as => singular_name do
          with_scope_level(:new) do # name_for_action uses this for the new_thing naming magic
            get :new
          end
          scope :path => ':id' do
            with_scope_level(:member) do
              get :edit, :as => 'edit', :path => 'edit'
              get :show
              put :update
              delete :destroy
            end
          end
        end
      end
    end
  end

  def self.date_routes(mapper)
    mapper.instance_exec do
      scope :path => ':year(/:month(/:day))', :as => 'dates', :controller => 'dates' do
        match :action => :show
        yield if block_given?
      end
    end
  end

  def self.location_routes(mapper)
    mapper.instance_exec do
      scope :path => ':country(/:city)', :as => 'locations', :controller => 'locations' do
        match :action => :show
        scope :module => 'locations' do
          yield if block_given?
        end
      end
    end
  end
end

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
    end
    scope :as => 'wing' do
      match :as => 'new', :path => 'new', :action => :new, :via => :get
      scope :path => ':id' do
        match :as => 'edit', :path => 'edit', :action => :edit, :via => :get
        match :action => :show, :via => :get
        match :action => :update, :via => :put
        match :action => :destroy, :via => :delete
      end
    end
  end

  scope :path => '/pings', :controller => 'pings' do
    scope :as => 'pings' do
      match :action => :index, :via => :get
      match :action => :create, :via => :post
      with_scope_level(:collection) do
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
          match :action => 'show', :via => :get
          match :action => 'update', :via => :put
          match :action => :destroy, :via => :delete
        end
      end
    end
  end

  scope :path => '/fings', :controller => 'fings' do
    scope :as => 'fings' do
      with_scope_level(:collection) do
        get :index
        post :create
        get :yay, :as => 'yay', :path => 'yay'
      end
    end
    scope :as => 'fing' do
      with_scope_level(:new) do
        get :new
      end
      scope :path => ':id' do
        with_scope_level(:member) do
          get :edit
          # get :edit, :as => 'edit', :path => 'edit'
          get :show
          put :update
          delete :destroy
        end
      end
    end
  end

  RH.fake_resources(self, 'whelks')

  RH.date_routes(self) do
    get :nah, :as => 'nah'
  end

  scope :module => 'hello' do
    RH.date_routes(self) do
      get :nah, :as => 'nah'
    end
  end

  scope :controller => 'hello', :path => 'hello', :as => 'hello' do
    match :action => :show
    scope :module => 'hello' do
      RH.location_routes(self) do
        RH.date_routes(self)
      end
    end
  end
  
  RH.location_routes(self) do
    resources :sweets
  end
end
