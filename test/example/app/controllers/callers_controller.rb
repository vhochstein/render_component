class CallersController < ApplicationController
  def calling_from_controller
    render_component(:controller => "callees", :action => "being_called")
  end

  def calling_from_controller_with_params
    render_component(:controller => "callees", :action => "being_called", :params => { "name" => "David" })
  end

  def calling_from_controller_with_session
    session['name'] = 'Bernd'
    render_component(:controller => "callees", :action => "being_called")
  end

  def calling_from_controller_with_different_status_code
    render_component(:controller => "callees", :action => "blowing_up")
  end

  def calling_from_template
    render :inline => "Ring, ring: <%= render_component(:controller => 'callees', :action => 'being_called') %>"
  end

  def internal_caller
    render :inline => "Are you there? <%= render_component(:action => 'internal_callee') %>"
  end

  def internal_callee
    render :text => "Yes, ma'am"
  end

  def set_flash
    render_component(:controller => "callees", :action => "set_flash")
  end

  def use_flash
    render_component(:controller => "callees", :action => "use_flash")
  end

  def calling_redirected
    render_component(:controller => "callees", :action => "redirected")
  end

  def calling_redirected_as_string
    render :inline => "<%= render_component(:controller => 'callees', :action => 'redirected') %>"
  end

  def rescue_action(e) raise end
end
