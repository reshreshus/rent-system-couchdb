class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  # skip_before_action :authenticate_request, only: :create
  wrap_parameters :user, include: [:name, :email, :username,
                                   :surname, :phone, :role_id,
                                   :password, :password_confirmation]

  # GET /users
  def index
    @users = User.all
    render json: {status: 'success', data: @users}, status: :ok
  end

  # GET /users/1
  def show
    render json: {status: 'success', data: @user}, status: :ok
  end

  # GET /current_user
  def current_user
    render json: { status: 'success', data: AuthorizeApiRequest.call(request.headers).result }
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: {status: 'success', data: @user}, status: :created, location: @user
    else
      render json: {status: 'fail', data: @user.errors}, status: :unprocessable_entity
    end
  end

  # GET /users/{id}/items
  def get_user_items
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @items = Item.where(user_id: @current_user.id)
    render json: { data: @items }
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: {status: 'success', data: @user}, status: :ok
    else
      render json: {status: 'fail', data: @user.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render json: {status: 'success', data: nil}, status: :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    # to create a user, we need only these parameters
    params.require(:user).permit(:password, :email, :role_id, :name, :surname, :phone)
  end
end