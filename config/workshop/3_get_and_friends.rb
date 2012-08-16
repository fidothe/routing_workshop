RoutingWorkshop::Application.routes.draw do
  resources :things do
    collection do
      get :yay
    end
    member do
      get :nay
    end
  end

  scope :path => '/fings', :controller => 'fings' do
    scope :as => 'fings' do
      with_scope_level(:collection) do
        get :index
        post :create
        # get :new, :as => 'new', :path => 'new'
        # contrast that with with_scope_level(:new)
        get :yay, :as => 'yay', :path => 'yay'
      end
    end
    scope :as => 'fing' do
      # with_scope_level(:member) do
      #   get :new, :as => 'new', :path => 'new'
      # end
      with_scope_level(:new) do
        get :new, :path => 'new'
      end
      scope :path => ':id' do
        with_scope_level(:member) do
          # do get :show first...
          # get :edit, :as => 'edit', :path => 'edit'
          get :edit
          # get :nay, :as => 'nay', :path => 'nay'
          get :nay
          get :show
          put :update
          delete :destroy
        end
      end
    end
  end
end
