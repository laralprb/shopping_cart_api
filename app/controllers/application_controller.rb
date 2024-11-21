class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :null_session
  
  skip_before_action :verify_authenticity_token
  before_action :set_session_options
  
  private
  
  def set_session_options
    request.session_options[:skip] = false
  end
end
