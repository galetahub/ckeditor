# frozen_string_literal: true

require 'action_policy'

module Ckeditor
  module Hooks
    # This adapter is for the Action Policy[https://github.com/palkan/action_policy] authorization library.
    # You can create another adapter for different authorization behavior, just be certain it
    # responds to each of the public methods here.
    class ActionPolicyAuthorization
      include Ckeditor::Helpers::Controllers

      # See the +authorize_with+ config method for where the initialization happens.
      def initialize(controller)
        @controller = controller
      end

      # This method is called in every controller action and should raise an exception
      # when the authorization fails. The first argument is the name of the controller
      # action as a symbol (:create, :destroy, etc.). The second argument is the actual model
      # instance if it is available.
      def authorize(_action, model_object = nil)
        @controller.authorize!(model_object, context: {user: @controller.ckeditor_current_user})
      end

      # This method is called primarily from the view to determine whether the given user
      # has access to perform the action on a given model. It should return true when authorized.
      # This takes the same arguments as +authorize+. The difference is that this will
      # return a boolean whereas +authorize+ will raise an exception when not authorized.
      def authorized?(action, model_object = nil)
        if action
          @controller.allowed_to?(:"#{action}?",
                                  model_object,
                                  context: {user: @controller.ckeditor_current_user})
        end
      end
    end
  end
end

Ckeditor::AUTHORIZATION_ADAPTERS[:action_policy] = Ckeditor::Hooks::ActionPolicyAuthorization
