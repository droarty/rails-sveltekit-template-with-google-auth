module Api
  module V1
    class UsersController < BaseController
      def me
        render json: { user: { id: current_user.id, email: current_user.email, role: current_user.role } }
      end
    end
  end
end
