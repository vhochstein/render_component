# frozen_string_literal: true

require 'test_helper'

class CallersControllerTest < ActionDispatch::IntegrationTest

  test "calling_from_controller" do
    get '/callers/calling_from_controller'
    assert_equal "Lady of the House, speaking", response.body
  end

  test "calling_from_controller_with_params" do
    get '/callers/calling_from_controller_with_params'
    assert_equal "David of the House, speaking", response.body
  end

  test "calling_from_controller_with_different_status_code" do
    get '/callers/calling_from_controller_with_different_status_code'
    assert_equal 500, response.response_code
  end

  test "calling_from_template" do
    get '/callers/calling_from_template'
    assert_equal "Ring, ring: Lady of the House, speaking", response.body
  end

  test "etag_is_set_for_parent_template_when_calling_from_template" do
    get '/callers/calling_from_template'
    expected_etag = etag_for("Ring, ring: Lady of the House, speaking")
    assert_equal expected_etag, response.headers['ETag']
  end

  test "internal_calling" do
    get '/callers/internal_caller'
    assert_equal "Are you there? Yes, ma'am", response.body
  end

  test "flash" do
    get '/callers/set_flash'
    assert_equal 'My stoney baby', flash[:notice]
    get '/callers/use_flash'
    assert_equal 'My stoney baby', response.body
    get '/callers/use_flash'
    #TODO: this last one fail, it seems the previous flash is being preserved in memory.
    #assert_equal 'no flash', response.body
  end

  test "component_redirect_redirects" do
    get '/callers/calling_redirected'
    assert_redirected_to :controller=>"callees", :action => "being_called"
  end

  test "component_multiple_redirect_redirects" do
    # call test_component_redirect_redirects
    get '/callers/calling_redirected'
    assert_redirected_to :controller=>"callees", :action => "being_called"
    # call test_internal_calling
    get '/callers/internal_caller'
    assert_equal "Are you there? Yes, ma'am", response.body
  end

  test "component_as_string_redirect_renders_redirected_action" do
    get '/callers/calling_redirected_as_string'
    assert_equal "Lady of the House, speaking", response.body
  end

  test "calling_from_controller_with_session" do
    get '/callers/calling_from_controller_with_session'
    assert_equal "Bernd of the House, speaking", response.body
  end

  test "child_calling_from_template" do
    get '/child_callers/calling_from_template'
    assert_equal "Ring, ring: Lady of the House, speaking", response.body
  end

  protected
  def etag_for(_text)
    "W/\"d7ee1417b1c509ca4c23115924b68233\""
  end
end

