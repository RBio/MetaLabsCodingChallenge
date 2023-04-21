class Api::AuthController < ActionController::API
  def login
    user = User.find_by_email(login_params[:email])
    if user&.valid_password?(login_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end