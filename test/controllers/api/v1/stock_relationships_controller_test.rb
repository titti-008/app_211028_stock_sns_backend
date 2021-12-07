require "test_helper"

class Api::V1::StockRelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_stock_relationships_create_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_stock_relationships_destroy_url
    assert_response :success
  end
end
