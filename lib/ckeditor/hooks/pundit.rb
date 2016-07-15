require 'pundit'

module Ckeditor
  module Hooks
    # This adapter is for the Pundit[https://github.com/elabs/pundit] authorization library.
    # You can create another adapter for different authorization behavior, just be certain it
    # responds to each of the public methods here.
    class PunditAuthorization
      include Ckeditor::Helpers::Controllers

      # See the +authorize_with+ config method for where the initialization happens.
      def initialize(controller)
        @controller = controller
        @controller.extend ControllerExtension
      end

      # This method is called in every controller action and should raise an exception
      # when the authorization fails. The first argument is the name of the controller
      # action as a symbol (:create, :destroy, etc.). The second argument is the actual model
      # instance if it is available.
      def authorize(action, model_object = nil)
        raise Pundit::NotAuthorizedError unless authorized?(action, model_object)
      end

      # This method is called primarily from the view to determine whether the given user
      # has access to perform the action on a given model. It should return true when authorized.
      # This takes the same arguments as +authorize+. The difference is that this will
      # return a boolean whereas +authorize+ will raise an exception when not authorized.
      def authorized?(action, model_object = nil)
        Pundit.policy(@controller.current_user_for_pundit, model_object).public_send(action + '?') if action
      end

      module ControllerExtension
        def current_user_for_pundit
          # use ckeditor_current_user instead of default current_user so it works with
          # whatever current user method is defined with Ckeditor
          ckeditor_current_user
        end
      end
    end
  end
end

Ckeditor::AUTHORIZATION_ADAPTERS[:pundit] = Ckeditor::Hooks::PunditAuthorization
