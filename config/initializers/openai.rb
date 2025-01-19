return if ENV["SECRET_KEY_BASE_DUMMY"].present?

OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai.access_token
  config.log_errors = Rails.env.local?
end
