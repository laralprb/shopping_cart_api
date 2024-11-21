class CartsController < ApplicationController
  def show
    cart = current_cart
    render json: cart_response(cart)
  end

  def create
    @cart = Cart.create(last_interaction_at: Time.current)
    session[:cart_id] = @cart.id
    render json: cart_response(@cart), status: :created
  end

  def add_items
    cart = current_cart
    cart.mark_as_active if cart.abandoned?
    product = Product.find(params[:product_id])
    
    cart_product = cart.cart_products.find_or_initialize_by(product: product)
    cart_product.quantity = cart_product.quantity.to_i + params[:quantity].to_i
    
    if cart_product.save
      render json: cart_response(cart)
    else
      render json: { error: 'Nao foi possivel atualizar a quantidade' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Produto nao encontrado' }, status: :not_found
  end

  def add_item
    add_items
  end

  def remove_product
    cart = current_cart
    
    if cart.cart_products.empty?
      render json: { error: 'Carrinho vazio' }, status: :unprocessable_entity
      return
    end

    cart_product = cart.cart_products.find_by(product_id: params[:product_id])
    
    if cart_product
      cart_product.destroy
      cart.reload
      render json: cart_response(cart)
    else
      render json: { error: 'Produto nao encontrado no carrinho' }, status: :not_found
    end
  end

  private

  def current_cart
    if session[:cart_id]
      Cart.find_by(id: session[:cart_id]) || create_cart
    else
      create_cart
    end
  end

  def create_cart
    cart = Cart.create!(last_interaction_at: Time.current)
    session[:cart_id] = cart.id
    cart
  end

  def cart_response(cart)
    {
      id: cart.id,
      products: cart.cart_products.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          price: item.product.unit_price,
          total_price: item.quantity * item.product.unit_price
        }
      end,
      total_price: cart.cart_products.sum { |item| item.quantity * item.product.unit_price }
    }
  end

  def empty_cart_response(cart)
    {
      id: cart.id,
      products: [],
      total_price: 0,
      message: "Carrinho vazio"
    }
  end
end
