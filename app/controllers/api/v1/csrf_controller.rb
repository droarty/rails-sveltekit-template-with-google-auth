module Api
  module V1
    class CsrfController < ApplicationController
      protect_from_forgery with: :null_session

      def show
        cookies["XSRF-TOKEN"] = {
          value: form_authenticity_token,
          same_site: :lax,
          secure: Rails.env.production?
        }
        render json: { csrf_token: form_authenticity_token }
      end
    end
  end
end
