require File.dirname(__FILE__) + '/../test_helper'
require 'marathonr_controller'

# Re-raise errors caught by the controller.
class MarathonrController; def rescue_action(e) raise e end; end

class MarathonrControllerTest < Test::Unit::TestCase
  def setup
    @controller = MarathonrController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
