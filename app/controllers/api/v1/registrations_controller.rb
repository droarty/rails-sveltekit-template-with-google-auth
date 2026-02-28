module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :verify_authenticity_token
      respond_to :json

      def create
        build_resource(sign_up_params)
        resource.save
        if resource.persisted?
          sign_in(resource_name, resource)
          render json: { user: user_json(resource) }, status: :created
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def user_json(user)
        { id: user.id, email: user.email, role: user.role }
      end
    end
  end
end
