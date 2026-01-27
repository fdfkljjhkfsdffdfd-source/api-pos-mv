class PaymentsController < ApplicationController


  def cash
    receipt = Payment.cash!(user: @current_user)
    render json: {
      receipt: receipt
    }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end





  
end
