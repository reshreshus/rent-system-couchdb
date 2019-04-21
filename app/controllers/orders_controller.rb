class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all

    render json: {status: 'success', data: @orders}, status: :ok
  end

  # GET /orders/1
  def show
    render json: {status: 'success', data: @order}, status: :ok
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    # render json: {data: @order}, status: :ok
    # @lessee = User.where(id: @order.user_id).first

    @lessee = User.get(@order.user_id)
    # render json: {data: @lessee}, status: :ok
    if @lessee.nil?
      render json: { status: 'fail', data: "", message: 'No such user' }, status: :unprocessable_entity
      return
    end
    @item = Item.get(@order.item_id)
    if @item.nil?
      render json: { status: 'fail', data: "", message: 'No such item' }, status: :unprocessable_entity
      return
    end
    # @possible_existing_orders = Order.where(item_id: @order.item_id)
    @possible_existing_orders = Order.by_item_id.key(@order.item_id)

    # render json: {data: @item}, status: :ok

    # minor changes for logic
    # flag = false
    # @possible_existing_orders.each do |existing_order|
    #   if [1, 4, 5, 6, 7].include? existing_order.status
    #     flag = true
    #     break
    #   end
    # end

    # if flag


    if @lessee['_id'] == @item.user_id
      render json: { status: 'fail', data: "", message: 'You cannot rent from yourself' }, status: :unprocessable_entity
    else
      if @order.save
        # !
        @item.orders << @order
        @item.save
        render json: {status: 'success', data: @order}, status: :ok
      else
        render json: {status: 'fail', data: @order.errors}, status: :unprocessable_entity
      end
    end



    # else
    #   render json: { status: 'fail', data: '', message: 'Order is active' }, status: :ok
    # end
  end

  # PATCH/PUT /orders/1
  def update
    # if @order.update(order_params)
    if @order.update_attributes(order_params)
      render json: {status: 'success', data: @order}, status: :ok
    else
      render json: {status: 'fail', data: @order.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    render json: {status: 'success', data: :nil}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:item_id, :user_id, :duration, :status, :description)
    end
end
