Rails.application.config.action_mailer.default_url_options = { host: ENV.fetch('RAILS_APP_HOST') }
Rails.application.config.action_mailer.delivery_method = :smtp
if Rails.env.production?
  Rails.application.config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    user_name: ENV.fetch('GMAIL_USERNAME'),
    password: ENV.fetch('GMAIL_PASSWORD'),
    authentication: :plain,
    enable_starttls_auto: true
  }
else
  Rails.application.config.action_mailer.smtp_settings = {
    address: 'localhost',
    port: 1025
  }
end
