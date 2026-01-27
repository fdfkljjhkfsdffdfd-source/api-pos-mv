require "test_helper"

class ReceiptItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receipt_item = receipt_items(:one)
  end

  test "should get index" do
    get receipt_items_url, as: :json
    assert_response :success
  end

  test "should create receipt_item" do
    assert_difference("ReceiptItem.count") do
      post receipt_items_url, params: { receipt_item: { price: @receipt_item.price, quantity: @receipt_item.quantity, receipt_id: @receipt_item.receipt_id, sku_master_id: @receipt_item.sku_master_id } }, as: :json
    end

    assert_response :created
  end

  test "should show receipt_item" do
    get receipt_item_url(@receipt_item), as: :json
    assert_response :success
  end

  test "should update receipt_item" do
    patch receipt_item_url(@receipt_item), params: { receipt_item: { price: @receipt_item.price, quantity: @receipt_item.quantity, receipt_id: @receipt_item.receipt_id, sku_master_id: @receipt_item.sku_master_id } }, as: :json
    assert_response :success
  end

  test "should destroy receipt_item" do
    assert_difference("ReceiptItem.count", -1) do
      delete receipt_item_url(@receipt_item), as: :json
    end

    assert_response :no_content
  end
end
