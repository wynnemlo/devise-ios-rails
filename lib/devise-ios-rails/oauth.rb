module DeviseIosRails
  module OAuth
    def self.included receiver
      receiver.extend ClassMethods
      receiver.validates_with OauthTokenValidator, unless: 'provider.blank?'
      receiver.validates :uid, uniqueness: { scope: :provider },
                               allow_nil: true, allow_blank: true
    end

    def email_required?
      super && password_required?
    end

    def password_required?
      super && provider.blank?
    end
  

    module ClassMethods
      def from_oauth attributes
        if existing_user = User.where(attributes.slice(:email)).first
          return existing_user
        else 
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
end
