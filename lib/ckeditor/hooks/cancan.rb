require 'cancan'

module Ckeditor
  module Hooks
    # This adapter is for the CanCan[https://github.com/ryanb/cancan] authorization library.
    # You can create another adapter for different authorization behavior, just be certain it
    # responds to each of the public methods here.
    class CanCanAuthorization
      # See the +authorize_with+ config method for where the initialization happens.
      def initialize(controller, ability = ::Ability)
        @controller = controller
        @controller.instance_variable_set '@ability', ability
        @controller.extend ControllerExtension
        @controller.current_ability.authorize! :access, :ckeditor
      end

      # This method is called in every controller action and should raise an exception
      # when the authorization fails. The first argument is the name of the controller
      # action as a symbol (:create, :destroy, etc.). The second argument is the actual model
      # instance if it is available.
      def authorize(action, model_object = nil)
        if action
          @controller.instance_variable_set(:@_authorized, true)
          @controller.current_ability.authorize!(action.to_sym, model_object)
        end
      end

      # This method is called primarily from the view to determine whether the given user
      # has access to perform the action on a given model. It should return true when authorized.
      # This takes the same arguments as +authorize+. The difference is that this will
      # return a boolean whereas +authorize+ will raise an exception when not authorized.
      def authorized?(action, model_object = nil)
        @controller.current_ability.can?(action.to_sym, model_object) if action
      end

      module ControllerExtension
        def current_ability
          # use ckeditor_current_user instead of default current_user so it works with
          # whatever current user method is defined with Ckeditor
          @current_ability ||= @ability.new(ckeditor_current_user)
        end
      end
    end
  end
end

Ckeditor::AUTHORIZATION_ADAPTERS[:cancan] = Ckeditor::Hooks::CanCanAuthorization
