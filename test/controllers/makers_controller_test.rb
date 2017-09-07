require 'test_helper'

class MakersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get makers_index_url
    assert_response :success
  end

end
