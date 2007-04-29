require File.dirname(__FILE__) + '/../test_helper'
require 'schedule_entries_controller'

# Re-raise errors caught by the controller.
class ScheduleEntriesController; def rescue_action(e) raise e end; end

class ScheduleEntriesControllerTest < Test::Unit::TestCase
  fixtures :schedule_entries

  def setup
    @controller = ScheduleEntriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:schedule_entries)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:schedule_entry)
    assert assigns(:schedule_entry).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:schedule_entry)
  end

  def test_create
    num_schedule_entries = ScheduleEntry.count

    post :create, :schedule_entry => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_schedule_entries + 1, ScheduleEntry.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:schedule_entry)
    assert assigns(:schedule_entry).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ScheduleEntry.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ScheduleEntry.find(1)
    }
  end
end
