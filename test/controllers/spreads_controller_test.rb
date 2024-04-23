require "test_helper"

class SpreadsControllerTest < ActionDispatch::IntegrationTest
  test "should get calculate" do
    get spreads_calculate_url
    assert_response :success
  end

  test "should get index" do
    get spreads_index_url
    assert_response :success
  end
end
