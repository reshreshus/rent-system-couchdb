class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: [:index, :show]
  # wrap_parameters :user, include: [:description, :duration, :username,
  #                                  :surname, :phone, :role_id,
  #                                  :password, :password_confirmation]


  # GET /items
  def index
    @items = Item.all

    render json: {status: 'success', data: @items}, status: :ok
  end

  # GET /items/1
  def show
    # params[:id]
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
    # I don't know why, but update doesn't work and update_attributes does
    # if @item.update(item_params)
    if @item.update_attributes(item_params)
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
      # @item = Item.find(params[:id])
      @item = Item.get(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:user_id, :title, :duration, :description, :subcategory_id, :price, :image)
    end
end
