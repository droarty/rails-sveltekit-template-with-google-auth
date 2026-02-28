module Api
  module V1
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController
      skip_before_action :verify_authenticity_token

      def google_oauth2
        @user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in @user
        redirect_to "#{frontend_url}/", allow_other_host: true
      end

      def failure
        redirect_to "#{frontend_url}/login?error=oauth_failed", allow_other_host: true
      end

      private

      def frontend_url
        Rails.application.credentials.dig(:google_auth, :frontend_url).to_s.chomp("/")
      end
    end
  end
end
