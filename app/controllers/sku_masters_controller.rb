class SkuMastersController < ApplicationController
  before_action :set_sku_master, only: %i[ show update destroy ]
  before_action :authenticate_request







  def by_category
    category_id = params[:category_id]
    @sku_masters = SkuMaster.by_category(category_id)
    render json: @sku_masters
  end



  # GET /sku_masters/search?q=keyword
  def search
    @sku_masters = SkuMaster.search(params[:keyword])
    render json: @sku_masters
  end




  
  # GET /sku_masters
  def index
    @sku_masters = SkuMaster.sku_master_all

    render json: @sku_masters
  end


  # GET /sku_masters
# GET /sku_masters/pagination
  def sku_master_pagination
    render json: SkuMaster.paginate_with_category(params)
  end














  # GET /sku_masters/1
  def show
    render json: @sku_master
  end

  # POST /sku_masters
  def create
    @sku_master = SkuMaster.new(sku_master_params)

    if @sku_master.save
      render json: @sku_master, status: :created, location: @sku_master
    else
      render json: @sku_master.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sku_masters/1
  def update
    if @sku_master.update(sku_master_params)
      render json: @sku_master
    else
      render json: @sku_master.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sku_masters/1
  # def destroy
  #   @sku_master.destroy
  # end

  def destroy
    if @sku_master.receipt_items.exists?
      render json: {
        error: {
          code: "SKU_IN_USE",
          message: "ไม่สามารถลบสินค้าได้ เนื่องจากถูกใช้งานในใบเสร็จแล้ว"
        }
      }, status: :unprocessable_entity
    else
      @sku_master.destroy
      head :no_content
    end
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sku_master
      @sku_master = SkuMaster.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sku_master_params
      params.require(:sku_master).permit(:name, :category_id, :amount, :price)
    end
end
