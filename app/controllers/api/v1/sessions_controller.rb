module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token, only: %i[create destroy]
      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        render json: { user: user_json(resource) }, status: :ok
      rescue ActionController::ParameterMissing
        render json: { error: "Invalid parameters" }, status: :bad_request
      end

      def destroy
        signed_in = current_user.present?
        sign_out(resource_name)
        if signed_in
          render json: { message: "Signed out successfully" }, status: :ok
        else
          render json: { error: "Not signed in" }, status: :unauthorized
        end
      end

      private

      def user_json(user)
        { id: user.id, email: user.email }
      end

      def respond_to_on_destroy
        # Overridden — handled in #destroy
      end
    end
  end
end
