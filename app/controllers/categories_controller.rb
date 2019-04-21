class CategoriesController < ApplicationController
  # TODO: This class is not supposed to work
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.all

    render json: {status: 'success', data: @categories}, status: :ok
  end

  # GET /categories/1
  def show
    render json: {status: 'success', data: @category}, status: :ok
  end

  # GET /categories/1/subcategories
  def get_subcategories
    @subcategories = Subcategory.where(:category_id => params[:id])
    render json: { status: 'success', data: @subcategories }
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: {status: 'success', data: @category}, status: :created, location: @category
    else
      render json: {status: 'fail', data: @category.errors}, status: :unprocessable_entity

    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render json: {status: 'success', data: @category}, status: :ok
    else
      render json: {status: 'fail', data: @category.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    render json: {status: 'success', data: nil}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      # to create a category, we need only these parameters
      params.require(:category).permit(:password, :email, :role_id)
    end
end
