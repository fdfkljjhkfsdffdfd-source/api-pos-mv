require "test_helper"

class ReceiptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receipt = receipts(:one)
  end

  test "should get index" do
    get receipts_url, as: :json
    assert_response :success
  end

  test "should create receipt" do
    assert_difference("Receipt.count") do
      post receipts_url, params: { receipt: { receipt_no: @receipt.receipt_no, total_amount: @receipt.total_amount, total_summary: @receipt.total_summary, user_id: @receipt.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show receipt" do
    get receipt_url(@receipt), as: :json
    assert_response :success
  end

  test "should update receipt" do
    patch receipt_url(@receipt), params: { receipt: { receipt_no: @receipt.receipt_no, total_amount: @receipt.total_amount, total_summary: @receipt.total_summary, user_id: @receipt.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy receipt" do
    assert_difference("Receipt.count", -1) do
      delete receipt_url(@receipt), as: :json
    end

    assert_response :no_content
  end
end
