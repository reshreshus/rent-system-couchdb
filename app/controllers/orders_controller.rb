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

    if @order.save
      render json: {status: 'success', data: @order}, status: :ok
    else
      render json: {status: 'fail', data: @order.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: {status: 'success', data: @order}, status: :ok
    else
      render json: {status: 'fail', data: @order.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    render json: {status: 'success', data: nil}, status: :ok
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
