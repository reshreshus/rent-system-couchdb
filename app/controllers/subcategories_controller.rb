class SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: [:index, :show, :show_items]


  # GET /subcategories
  def index
    require 'json'
    @subcategories = Subcategory.all
    # JSON.parse(@subcategories)
    subcategories_hash = JSON.parse(@subcategories.to_json())

    subcategory_all = {
      'title' => 'Show all',
      'description' => 'show items of all categories',
      '_id' => 0
    }
    subcategories_hash.unshift(subcategory_all) 

    # @subcategories = Subcategory.new(subcategories_hash)
    # JSON.pretty_generate(subcategories_hash)
    render json: {status: 'success', data: subcategories_hash}, status: :ok
  end

  # GET /subcategories/1
  def show
    render json: {status: 'success', data: @subcategory}, status: :ok
  end

  # GET /subcategories/1/items
  def show_items
    if params[:id] == '0'
      @items = Item.all
    else
      @items = Item.by_subcategory_id.key(params[:id])
    end
    # @items.each do |item|:
    #   item['subcategory'] = Subcategory.get(item['subcategory_id'])
    # end

    per_page = 10
    total = @items.count
    if total % per_page == 0
      total_pages = total / per_page
    else
      total_pages = total / per_page + 1
    end
    

    if params[:id] == '0'
      @part_items = Item.all.page(params[:page]).per(per_page)
    else
      @part_items = Item.by_subcategory_id.key(params[:id]).page(params[:page]).per(per_page)
    end

    @part_items.each do |item|
      item['subcategory'] = Subcategory.get(item['subcategory_id'])['title']
    end

      render json: {status: 'success', data: {list: @part_items, paginator: {total: total, per_page: per_page, current_page: params[:page].to_i, total_pages: total_pages}}}, status: :ok
  end

  # POST /subcategories
  def create
    @current_user = AuthorizeApiRequest.call(request.headers).result
    if @current_user.role_id == 2
      @subcategory = Subcategory.new(subcategory_params)
      if @subcategory.save
        # render json: @subcategory, status: :created, location: @subcategory
        render json: {status: 'success', data: @subcategory}, status: :created, location: @subcategory
      else
        #render json: @subcategory.errors, status: :unprocessable_entity
        render json: {status: 'fail', data: @subcategory.errors}, status: :unprocessable_entity
      end
    else
      render json: {status: 'fail', data: nil}, status: :forbidden
    end
  end

  # PATCH/PUT /subcategories/1
  def update
    # if @subcategory.update(subcategory_params)
    if @subcategory.update_attributes(subcategory_params)
      render json: {status: 'success', data: @subcategory}, status: :ok
    else
      render json: {status: 'fail', data: @subcategory.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /subcategories/1
  def destroy
    @subcategory.destroy
    render json: {status: 'success', data: nil}, status: :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_subcategory
    @subcategory = Subcategory.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def subcategory_params
    #TODO
    params.require(:subcategory).permit(:title, :description)
  end
end