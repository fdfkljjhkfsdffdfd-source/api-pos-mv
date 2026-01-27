class ReceiptItemsController < ApplicationController
  before_action :set_receipt_item, only: %i[ show update destroy ]








  
  def receipt_items_by_receipt
    if receipt_items = ReceiptItem.by_receipt(params[:receipt_id])
      render json: receipt_items
    else
      render json: { error: "Receipt items not found" }, status: :not_found
    end
    
  end










  # GET /receipt_items
  def index
    @receipt_items = ReceiptItem.all

    render json: @receipt_items
  end

  # GET /receipt_items/1
  def show
    render json: @receipt_item
  end

  # POST /receipt_items
  def create
    @receipt_item = ReceiptItem.new(receipt_item_params)

    if @receipt_item.save
      render json: @receipt_item, status: :created, location: @receipt_item
    else
      render json: @receipt_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /receipt_items/1
  def update
    if @receipt_item.update(receipt_item_params)
      render json: @receipt_item
    else
      render json: @receipt_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /receipt_items/1
  def destroy
    @receipt_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt_item
      @receipt_item = ReceiptItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def receipt_item_params
      params.require(:receipt_item).permit(:receipt_id, :sku_master_id, :quantity, :price)
    end
end
