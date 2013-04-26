class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup_gon

  protected

  def not_authenticated
    redirect_to signup_path, alert: "Please login first."
  end

  def setup_gon
    Gon.global.controller = controller_name
    Gon.global.action     = action_name

    if current_user
      Gon.global.user     = current_user.as_json.merge({roles: current_user.roles_for_resource(nil).map(&:name)})
    end
  end

end
