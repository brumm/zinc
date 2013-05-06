class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup_gon

  protected

  def not_authenticated
    redirect_to signup_path, alert: "Please login first."
  end

  def setup_gon
    Gon.global.controller = controller_name.singularize.titlecase
    Gon.global.action     = action_name
    Gon.global.user       = (current_user || User.new).as_json
    Gon.global.debug      = Rails.env.development?
  end

end
