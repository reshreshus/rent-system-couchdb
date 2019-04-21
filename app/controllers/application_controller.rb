# require_relative '../../app/helpers/json_response'
class ApplicationController < ActionController::API
  include Response

  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    # render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    json_response(nil, :unauthorized) unless @current_user
    # render json: { error: 'Not Authorized' }
  end

end