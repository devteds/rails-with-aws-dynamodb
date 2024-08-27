class ProductsController < ApplicationController
  def index
    render json: Product.scan.find_all.map(&:to_h)
  end
end
