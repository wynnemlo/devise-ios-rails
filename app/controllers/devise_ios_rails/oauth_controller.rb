module DeviseIosRails
  class OauthController < ApplicationController
    skip_before_action :verify_authenticity_token

    respond_to :json

    def facebook
      respond_with User.from_oauth(user_params)
    end

    private

    def user_params
      params.require(:user).permit(:email, :provider, :uid, :oauth_token)
    end
  end
end
