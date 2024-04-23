require "test_helper"

class SpreadAlertsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get spread_alerts_create_url
    assert_response :success
  end

  test "should get polling" do
    get spread_alerts_polling_url
    assert_response :success
  end
end
