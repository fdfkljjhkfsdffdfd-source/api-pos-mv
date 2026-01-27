require "test_helper"

class SkuMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sku_master = sku_masters(:one)
  end

  test "should get index" do
    get sku_masters_url, as: :json
    assert_response :success
  end

  test "should create sku_master" do
    assert_difference("SkuMaster.count") do
      post sku_masters_url, params: { sku_master: { amount: @sku_master.amount, category_id: @sku_master.category_id, name: @sku_master.name, price: @sku_master.price } }, as: :json
    end

    assert_response :created
  end

  test "should show sku_master" do
    get sku_master_url(@sku_master), as: :json
    assert_response :success
  end

  test "should update sku_master" do
    patch sku_master_url(@sku_master), params: { sku_master: { amount: @sku_master.amount, category_id: @sku_master.category_id, name: @sku_master.name, price: @sku_master.price } }, as: :json
    assert_response :success
  end

  test "should destroy sku_master" do
    assert_difference("SkuMaster.count", -1) do
      delete sku_master_url(@sku_master), as: :json
    end

    assert_response :no_content
  end
end
