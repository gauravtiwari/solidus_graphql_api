# frozen_string_literal: true

require 'spree/core'
require 'solidus_graphql_api'

module SolidusGraphqlApi
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions
    engine_name 'solidus_graphql_api'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.autoload_paths << File.expand_path('..', __dir__)

    initializer "solidus_graphql_api.setup_batch_loader_middleware" do |app|
      app.middleware.use BatchLoader::Middleware
    end
  end
end
