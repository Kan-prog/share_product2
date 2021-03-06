class ProductsController < ApplicationController
  before_action :authenticate_college!, only: [:new, :create, :edit, :update, :destroy]
  # before_action :authenticate_company!, only: [:show]
  before_action :require_current_college, only: [:edit, :update, :destroy]
  protect_from_forgery except: :create
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    3.times { @product.pictures.build }
    # @product.pictures.build
  end

  def create
    @product = current_college.products.new(product_params)

    if @product.save
      flash[:success] = "投稿しました"
      redirect_to products_path
    else
      flash.now[:danger] = "投稿に失敗しました"
      render("/products/new")
    end
  end
  
  def edit
    @product = Product.find_by(id: params[:id])
  end
  
  def update
    @product = Product.find_by(id: params[:id])
    if @product.update(product_params)
      flash[:success] = "保存しました"
      redirect_to products_path
    else
      flash.now[:danger] = "保存できませんでした"
      render :edit
    end
  end
  
  def show
    @product = Product.find_by(id: params[:id])
    @comments = @product.comments
    @comment = Comment.new
  end
  
  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy
    flash[:warning] = "削除しました"
    redirect_to products_path
  end

  # def all_destroy
  #   @products = Product.all
  #   @products.each do |product|
  #     product.destroy
  #   end
  #   flash[:warning] = "すべて削除しました"
  #   redirect_to("/products/index")
  # end
  
  private
    
    def product_params
      params.require(:product).permit(:title, :content, :price, pictures_attributes: [:id, :product_id, image: []])
      # params.require(:product).permit(:title, :content, :price, pictures_attributes: [:image])
    end
  
  
end
