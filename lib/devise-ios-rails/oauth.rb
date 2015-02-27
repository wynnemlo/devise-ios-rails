module DeviseIosRails
  module OAuth
    def self.included receiver
      receiver.extend ClassMethods
      receiver.validate :oauth_token_valid, unless: 'provider.blank?'
    end

    def email_required?
      super && password_required?
    end

    def password_required?
      super && provider.blank?
    end

    def oauth_token_valid
      send "validate_#{provider}_token"
    end

    def validate_facebook_token
      graph = Koala::Facebook::API.new oauth_token
      graph.get_object 'me'
    rescue Koala::Facebook::AuthenticationError => e
      errors.add :oauth_token, e.fb_error_message
    end

    def validate_google_token
      conn = Faraday.new url: 'https://www.googleapis.com'
      resp = conn.get "/oauth2/v1/tokeninfo?access_token=#{oauth_token}"
      if resp.status == 400
        error_description = JSON.parse(resp.body)['error_description']
        errors.add :oauth_token, error_description
      end
    end

    module ClassMethods
      def from_oauth attributes
        where(attributes.slice(:uid, :provider)).first_or_create do |user|
          user.email       = attributes[:email]
          user.provider    = attributes[:provider]
          user.uid         = attributes[:uid]
          user.oauth_token = attributes[:oauth_token]
        end
      end
    end
  end
end
