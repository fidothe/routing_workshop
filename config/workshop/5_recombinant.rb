module RH
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
        get :show
        scope :module => 'locations' do
          yield if block_given?
        end
      end
    end
  end

  def self.location_routes_2(mapper)
    mapper.instance_exec do
      scope_opts = {:path => ':country(/:city)', :as => 'locations', :controller => 'locations'}
      scope_opts[:module] = @scope[:controller] if @scope[:controller]
      scope scope_opts do
        with_scope_level(:member) do
          get :show
        end
        scope :module => 'locations' do
          yield if block_given?
        end
      end
    end
  end

  def self.date_routes_2(mapper)
    mapper.instance_exec do
      scope_opts = {:path => ':year(/:month(/:day))', :as => 'dates', :controller => 'dates'}
      scope_opts[:module] = @scope[:controller] if @scope[:controller] && @scope[:module].nil?
      scope scope_opts do
        get :show
        yield if block_given?
      end
    end
  end
end

RoutingWorkshop::Application.routes.draw do
  # step 1
  RH.date_routes(self) do
    get :nah, :as => 'nah'
  end

  # step 2
  scope :module => 'hello', :as => 'hello' do
    RH.date_routes(self) do
      get :nah, :as => 'nah'
    end
  end

  # step 3
  scope :controller => 'hello', :path => 'hello', :as => 'hello' do
    match :action => :show
    scope :module => 'hello' do
      RH.location_routes(self) do
        RH.date_routes(self)
      end
    end
  end

  # step 4
  RH.location_routes(self) do
    resources :sweets
  end

  # step 5 (first use the original location_routes)
  resources :whelks do
    member do
      RH.location_routes_2(self)
    end
  end

  # step 6 (return to step 3)
  scope :controller => 'bye', :path => 'bye', :as => 'bye' do
    match :action => :show, :via => :get
    RH.location_routes_2(self) do
      RH.date_routes(self)
    end
  end

  # step 7 (first use the original location_routes)
  resources :elks do
    member do
      RH.location_routes_2(self) do
        RH.date_routes_2(self)
      end
    end
  end
  resources :belts do
    member do
      RH.date_routes_2(self)
    end
  end
end
