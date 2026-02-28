class FrontendController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    cookies["XSRF-TOKEN"] = {
      value: form_authenticity_token,
      same_site: :lax,
      secure: Rails.env.production?
    }

    index_path = Rails.root.join("public", "frontend", "index.html")

    if index_path.exist?
      send_file index_path, type: "text/html", disposition: "inline"
    else
      render plain: "Frontend not built. Run `rails frontend:build`.", status: :not_found
    end
  end
end
