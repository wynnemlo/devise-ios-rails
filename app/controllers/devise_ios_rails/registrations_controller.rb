module DeviseIosRails
  class RegistrationsController < Devise::RegistrationsController
    Devise.mappings.keys.each do |key|
      acts_as_token_authentication_handler_for Object.const_get(key.to_s.classify)
      skip_before_filter :"authenticate_#{key.to_s}_from_token!", only: %i(new create cancel)
    end

    def authenticate_scope!
      send(:"authenticate_#{resource_name}_from_token!")
      self.resource = send(:"current_#{resource_name}")
    end

    def after_update_path_for(resource)
      send :"edit_#{resource_name}_registration_url"
    end

    def update_resource(resource, params)
      resource.attributes = params
      resource.save
    end
  end
end
