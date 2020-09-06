module Authentication
  extend ActiveSupport::Concern

  AUTHORIZATION_HEADER = 'Authorization'
  TOKEN_PATTERN = /^Bearer (?<token>.*)/

  included do
    before_action :authenticate
  end

  private

  def authenticate
    payload, _header = JWT.decode(bearer_token, Rails.application.secrets.secret_key_base)
    Current.user = User.find_by(id: payload['user_id'])
  rescue JWT::DecodeError, JWT::JWKError
    Current.user = nil
  end

  def bearer_token
    @bearer_token ||= request.headers[AUTHORIZATION_HEADER].to_s.match(TOKEN_PATTERN) do |match_data|
      match_data[:token]
    end
  end
end
