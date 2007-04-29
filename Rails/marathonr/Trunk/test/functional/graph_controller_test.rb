require File.dirname(__FILE__) + '/../test_helper'
require 'graph_controller'

# Re-raise errors caught by the controller.
class GraphController; def rescue_action(e) raise e end; end

class GraphControllerTest < Test::Unit::TestCase
  def setup
    @controller = GraphController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
