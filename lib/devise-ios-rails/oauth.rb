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
      graph = Koala::Facebook::API.new oauth_token
      graph.get_object 'me'
    rescue Koala::Facebook::AuthenticationError => e
      errors.add :oauth_token, e.fb_error_message
    end

    module ClassMethods
      def from_oauth attributes
        where(attributes).first_or_create do |user|
          user.email    = attributes[:email]
          user.provider = attributes[:provider]
          user.uid      = attributes[:uid]
        end
      end
    end
  end
end
