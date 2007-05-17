require File.dirname(__FILE__) + '/../test_helper'
require 'notes_controller'

# Re-raise errors caught by the controller.
class NotesController; def rescue_action(e) raise e end; end

class NotesControllerTest < Test::Unit::TestCase
  def setup
    @controller = NotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index
    flunk
  end
  
  def test_get_descr
    flunk
  end

  def test_update_position
    flunk
  end
  
  def test_destroy
    flunk    
  end
  
  def test_add_tag
    flunk
  end
  
  def test_search_by_tag
    flunk
  end
  
  def test_add_file
    flunk
  end
  
  def test_delete_file
    flunk
  end
  
end
