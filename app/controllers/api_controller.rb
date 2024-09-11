class ApiController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def decoded_token
    header = request.headers["Authorization"]
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
      rescue JWT::DecodeError, JWT::ExpiredSignature # If token is outdated then client resieves the propper message
        nil
      end
    end
  end

  def current_user
    return @user if @user  # if user cached no need to search the db
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @user = User.find_by(id: user_id)
    end
  end

  def authorized
    render json: { message: "Please log in" }, status: :unauthorized unless current_user
  end
end
