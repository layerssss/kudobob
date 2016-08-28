#Rails.application.config.action_cable.url = 'wss://example.com/cable'
Rails.application.config.action_cable.allowed_request_origins = [ "http://#{ENV['RAILS_APP_HOST']}" ]
