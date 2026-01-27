class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    auth_header =
      request.headers['Authorization'] ||
      request.headers['HTTP_AUTHORIZATION']

    Rails.logger.debug "AUTH HEADER RAW: #{auth_header.inspect}"

    return render json: { error: 'Unauthorized' }, status: :unauthorized if auth_header.blank?

    token = auth_header.split(' ').last

    decoded = JWT.decode(
      token,
      jwt_secret,
      true,
      algorithm: 'HS256'
    )[0]

    @current_user = User.find(decoded['user_id'])


    
  rescue JWT::ExpiredSignature
    render json: { error: 'Token expired' }, status: :unauthorized
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
    Rails.logger.warn "AUTH ERROR: #{e.class} - #{e.message}"
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def jwt_secret
    ENV.fetch('JWT_SECRET')
  end
end
