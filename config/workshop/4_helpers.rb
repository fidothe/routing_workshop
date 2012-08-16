module RH
  def self.fake_resources(mapper, plural_name)
    singular_name = plural_name.singularize
    mapper.instance_exec do
      scope :path => plural_name, :controller => plural_name do
        scope :as => plural_name do
          with_scope_level(:collection) do
            get :yay
            # get :new, :as => 'new', :path => 'new'
            # contrast that with with_scope_level(:new)
            get :index
            post :create
          end
        end
        scope :as => singular_name do
          with_scope_level(:new) do # name_for_action uses this for the new_thing naming magic
            get :new, :path => 'new'
          end
          scope :path => ':id' do
            with_scope_level(:member) do
              get :nay
              get :edit
              get :show
              put :update
              delete :destroy
            end
          end
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

  RH.fake_resources(self, 'whelks')
end
