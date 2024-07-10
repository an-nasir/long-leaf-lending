require "test_helper"

class LendingFormsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get lending_forms_new_url
    assert_response :success
  end
end
