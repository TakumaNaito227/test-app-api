Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        logger.debug(ENV["API_DOMAIN"])
        origins ENV["API_DOMAIN"] || ""

        resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
end
