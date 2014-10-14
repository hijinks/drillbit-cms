require 'test_helper'

module Drillbit
  class ProfileControllerTest < ActionController::TestCase
    test "should get edit" do
      get :edit
      assert_response :success
    end

  end
end
