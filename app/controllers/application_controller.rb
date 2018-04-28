class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

after_action :set_access_control_headers
  def handle_options_request
    head(:ok) if request.request_method == "OPTIONS"
  end
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
  end

  
end
