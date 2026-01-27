class CartItemsController < ApplicationController

  before_action :set_cart_item, only: %i[ show update destroy ]

  # GET /cart_items
  def index
    @cart_items = CartItem.all

    render json: @cart_items
  end

  # GET /cart_items/1
  def show
    render json: @cart_item
  end

  # POST /cart_items
  def create
    item = CartItem.add_item!(
      user: @current_user,
      sku_master_id: params[:cart_item][:sku_master_id],
      quantity: params[:cart_item][:quantity]
    )

    render json: item, status: :created
  end



















  # PATCH/PUT /cart_items/1
  def update
    if @cart_item.update(cart_item_params)
      render json: @cart_item
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cart_items/1
  def destroy
    @cart_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_item
      @cart_item = CartItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_item_params
      params.require(:cart_item).permit(:cart_id, :sku_master_id, :quantity, :price)
    end


end
