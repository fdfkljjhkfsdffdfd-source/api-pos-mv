class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :login_admin]




  def login 
    user = Auth.login(email = params[:username], password = params[:password])
    if user
      render json: user, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end



  def login_admin 
    user = Auth.login_admin(email = params[:username], password = params[:password])
    if user
      render json: user, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end




end