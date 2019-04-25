class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: [:index, :show]
  # wrap_parameters :user, include: [:description, :duration, :username,
  #                                  :surname, :phone, :role_id,
  #                                  :password, :password_confirmation]


  # GET /items
  def index
    @items = Item.all
    per_page = 10
    total = @items.count
    if total % per_page == 0
      total_pages = total / per_page
    else
      total_pages = total / per_page + 1
    end
    @part_items = Item.by_title.page(params[:page]).per(per_page)
      render json: {status: 'success', data: {list: @part_items, paginator: {total: total, per_page: per_page, current_page: params[:page].to_i, total_pages: total_pages}}}, status: :ok
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

  def geo_search
    @items = Item.all
    @max_price = max_price
    list = Array.new
    @item = Item.get(params[:id])
    @items.each do |item|
      if @item.subcategory_id == item.subcategory_id
        score = (@item.price.to_i - item.price.to_i).abs
      else
        score = @max_price + (@item.price.to_i - item.price.to_i).abs
      end

      list.push({ id: item.id, name: item.title, price: item.price, score: score, item: item})
    end
    list = list.sort_by { |hash| hash[:score].to_i }
    # list.reject! { |hash| hash[:id] == @item.id }
    list.delete_if { |hash| hash[:id] == @item.id }
    items = Array.new
    for i in (0..2)
      items.push( { item: list[i] } )
    end

    render json: { status: 'success', data: items}, status: :ok
  end

  def geo_search_full
    @items = Item.all
    @max_price = max_price
    list = Array.new
    @item = Item.get(params[:id])
    @items.each do |item|
      if @item.subcategory_id == item.subcategory_id
        score =  (@item.price.to_i - item.price.to_i).abs
      else
        score = @max_price + (@item.price.to_i - item.price.to_i).abs
      end

      list.push({ id: item.id, name: item.title, price: item.price, score: score })
    end
    # list = list.sort_by(&:price.to_i)
    list = list.sort_by { |hash| hash[:score].to_i }

    list.delete_if { |hash| hash[:id] == @item.id }
    render json: { status: 'success', data: list }
    # render json: { status: 'success', data: [ first: list[1], second: list[2], third: list[3] ] }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      # @item = Item.find(params[:id])
      @item = Item.get(params[:id])
    end

    def max_price
      price = 0
      @items = Item.all
      @items.each do |item|
        if item.price.to_i > price.to_i
          price = item.price.to_i
        end
      end
      price
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:user_id, :title, :duration, :description, :subcategory_id, :price, :image)
    end
end
