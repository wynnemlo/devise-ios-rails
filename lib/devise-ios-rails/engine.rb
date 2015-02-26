require 'devise-ios-rails/oauth'

module DeviseIosRails
  class Engine < ::Rails::Engine
    require 'koala'

    isolate_namespace DeviseIosRails
  end
end
