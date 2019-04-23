class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: :create
  wrap_parameters :user, include: [:name, :email, :username,
                                   :surname, :phone, :role_id,
                                   :password, :password_confirmation]

  include Response

  # GET /users
  def index
    @current_user = AuthorizeApiRequest.call(request.headers).result
    if @current_user.role_id == 2
      @users = User.all
      total_number = @users.count
      per_page = 10
      @users = User.by_email.page(params[:page]).per(per_page)
      if total_number % per_page == 0
        total_number_pages = total_number / per_page
      else
        total_number_pages = total_number / per_page + 1
      end
      render json: { status: :success, data: {total: total_number, per_page: per_page, current_page: params[:page].to_i, total_pages: total_number_pages, list: @users} }, status: :ok
    else
      render json: { status: :fail, data: nil }, status: :forbidden
    end

  end

  # GET /users/1
  def show
    json_response(@user, :ok)
    # render json: {status: 'success', data: @user}, status: :ok
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

  # GET /users/{id}/items - shows only items of current user - deprecated
  # GET /my-items/ items of current user
  def get_user_items
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @items = Item.by_user_id.key(@current_user.id)
    # Find_by_user_id returns first
    # @items = Item.find_by_user_id(@current_user.id)

    render json: { data: @items }
  end

  # GET /my-orders/rented
  def get_items_i_rented
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @orders = Order.by_user_id.key(@current_user.id)

    render json: { status: 'success', data: return_orders_output(@orders) }
  end

  # GET /my-orders/rent
  def get_items_i_rent
    @current_user = AuthorizeApiRequest.call(request.headers).result
    # @orders = Order.where("item_id IN (SELECT item_id FROM items WHERE user_id = #{@current_user.id})")
    # all my items that are rented by somebody
    # bad for document-based, though
    items = Item.by_user_id.key(@current_user.id)

    # render json: { status: 'success', data: items}

    orders = Array.new
    items.each do |item|
      if item['order_ids']
        # orders += item['order_ids']
        item['order_ids'].each do |order_id|
          orders << Order.get(order_id)
        end
      end
    end



    render json: { status: 'success', data: return_orders_output(orders) }
  end

  # PATCH/PUT /users/1
  def update
    if @user.update_attributes(user_params)
      render json: {status: 'success', data: @user}, status: :ok
    else
      render json: {status: 'fail', data: @user.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render json: {status: 'success', data: nil}, status: :no_content
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    # if User.exists?(id: params[:id])
      @user = User.find(params[:id])
    # else
      # json_response(nil, :not_found)
    # end
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    # to create a user, we need only these parameters
    params.require(:user).permit(:password, :email, :role_id, :name, :surname, :phone, :username)
  end

  def return_orders_output(orders)
    list_of_orders = []
    orders.each do |order|
      price = return_item_price order.item_id
      # @lessee = User.where(id: order.user_id).first
      @lessee = User.get(order.user_id)
      # @item = Item.where(id: order.item_id)
      @item = Item.get(order.item_id)
      # @lessor = User.where(id: @item.first.user_id).first
      @lessor = User.get(@item.user_id)
      list_of_orders << {id: order.id, item_id: order.item_id, user_id: order.user_id, duration: order.duration,
                      status: order.status, description: order.description, final_price: (price * order.duration.to_i),
                      lessee_email: @lessee.email, lessee_phone: @lessee.phone,
                         lessor_email: @lessor.email, lessor_phone: @lessor.phone,
                         created_at: order.created_at, updated_at: order.updated_at}
    end
    list_of_orders
  end

  def return_item_price(item_id)
    # Item.where(id: item_id).first.price
    Item.get(item_id).price
  end

end