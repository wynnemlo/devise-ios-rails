module DeviseIosRails
  class OauthController < ApplicationController
    respond_to :json

    def facebook
      user = User.create(
        email:    params[:user][:email],
        uid:      params[:user][:uid],
        provider: params[:user][:provider]
      )
      respond_with user
    end
  end
end
