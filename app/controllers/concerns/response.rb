module Response
  def json_response(object, status = :ok)
    if status == :ok || status == :created
      render json: { status: :success, data: object }, status: status
    elsif status == :no_content
      render json: {}, status: :no_content
    elsif status == :unauthorized
      render json: { status: :error, message: 'Not Authorized' }, status: :unauthorized
    elsif status == :not_found
      render json: { status: :error, message: 'Not Found' }, status: :not_found
    end
  end
end