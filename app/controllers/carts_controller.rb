class CartsController < ApplicationController
  before_action :authenticate_request
  before_action :set_cart, only: %i[ show update destroy ]












    def cart_by_user 
      user_id = params[:user_id]
      @cart = Cart.find_by(user_id: user_id, status: "active")
      if @cart
        render json: @cart
      else
        render json: { error: "Active cart not found for user_id #{user_id}" }, status: :not_found
      end
    end

















  # GET /carts
  def index
    @carts = Cart.all

    render json: @carts
  end

  # GET /carts/1
  def show
    render json: @cart
  end

  # POST /carts
  def create
    @cart = Cart.new(cart_params)

    if @cart.save
      render json: @cart, status: :created, location: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /carts/1
  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  # DELETE /carts/1
  def destroy
    @cart.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:user_id, :total_summary, :total_amount, :status)
    end
end
