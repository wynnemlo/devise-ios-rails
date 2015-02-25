module DeviseIosRails
  class OauthController < ApplicationController
    respond_to :json

    def facebook
      user = User.from_oauth(user_params)
      respond_with user
    end

    private

    def user_params
      params.require(:user).permit(:email, :provider, :uid)
    end
  end
end
