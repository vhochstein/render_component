class CalleesController < ActionController::Base
  def being_called
    render plain: "#{params[:name] || session[:name] || "Lady"} of the House, speaking"
  end

  def blowing_up
    render plain: "It's game over, man, just game over, man!", :status => 500
  end

  def set_flash
    flash[:notice] = 'My stoney baby'
    render plain: 'flash is set'
  end

  def use_flash
    render plain: (flash[:notice] || 'no flash')
  end

  def redirected
    redirect_to :controller => "callees", :action => "being_called"
  end

  def rescue_action(e)
    raise
  end
end
