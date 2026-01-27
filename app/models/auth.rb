class Auth < ApplicationRecord
  JWT_ALGORITHM = 'HS256'

  # =========================
  # Login
  # =========================
  def self.login(username, password)
    user = User.find_by(username: username)
    return nil unless user&.authenticate(password)

    respond_to_json(user)
  end

  def self.login_admin(username, password)
    user = User.find_by(username: username, role: 'admin')
    return nil unless user&.authenticate(password)

    respond_to_json(user)
  end

  # =========================
  # JWT
  # =========================
  def self.generate_token(user)
    payload = {
      user_id: user.id,
      exp: 24.hours.from_now.to_i
    }

    JWT.encode(payload, jwt_secret, JWT_ALGORITHM)
  end

  def self.decode_token(token)
    decoded = JWT.decode(
      token,
      jwt_secret,
      true,
      algorithm: JWT_ALGORITHM
    )[0]

    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  # =========================
  # Response
  # =========================
  def self.respond_to_json(user)
    {
      token: generate_token(user),
      user: {
        id: user.id,
        username: user.username,
        name: user.name,
        role: user.role
      }
    }
  end

  # =========================
  # Private
  # =========================
  def self.jwt_secret
    ENV.fetch('JWT_SECRET')
  end
end
