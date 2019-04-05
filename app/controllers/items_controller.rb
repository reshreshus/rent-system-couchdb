class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]
  # skip_before_action :authenticate_request, only: [:index, :show]

  # GET /items
  def index
    @items = Item.all

    render json: {status: 'success', data: @items}, status: :ok
  end

  # GET /items/1
  def show
    render json: {status: 'success', data: @item}, status: :ok
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: {status: 'success', data: @item}, status: :ok
    else
      render json: {status: 'fail', data: @item.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: {status: 'success', data: @item}, status: :ok
    else
      render json: {status: 'fail', data: @item.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    render json: {status: 'success', data: nil}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:user_id, :title, :description, :subcategory_id, :price)
    end
end
