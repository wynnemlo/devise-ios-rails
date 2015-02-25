module DeviseIosRails
  module OAuth
    def self.included receiver
      receiver.extend ClassMethods
    end

    def email_required?
      super && password_required?
    end

    def password_required?
      super && provider.blank?
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
