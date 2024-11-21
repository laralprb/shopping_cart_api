require 'rails_helper'

RSpec.describe "/carts", type: :request do
  describe "POST /add_items" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", unit_price: 10.0) }
    let!(:cart_product) { CartProduct.create(cart: cart, product: product, quantity: 1) }

    before do
      allow_any_instance_of(CartsController).to receive(:current_cart).and_return(cart)
    end

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_product.reload.quantity }.by(2)
      end
    end

    context 'when the product is not in the cart' do
      let(:new_product) { create(:product, name: "New Product", unit_price: 20.0) }

      it 'adds the product to the cart' do
        expect {
          post '/cart/add_items', params: { product_id: new_product.id, quantity: 1 }, as: :json
        }.to change(cart.cart_products, :count).by(1)
      end
    end

    context 'when the product does not exist' do
      it 'returns not found error' do
        post '/cart/add_items', params: { product_id: 999, quantity: 1 }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /cart" do
    it "creates a new cart" do
      expect {
        post '/cart', as: :json
      }.to change(Cart, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["products"]).to be_empty
      expect(json["total_price"]).to eq(0)
    end
  end

  describe "DELETE /cart/:product_id" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", unit_price: 10.0) }
    let!(:cart_product) { CartProduct.create(cart: cart, product: product, quantity: 1) }

    before do
      allow_any_instance_of(CartsController).to receive(:current_cart).and_return(cart)
    end

    context 'when the product is not in the cart' do
      it 'returns not found error' do
        delete "/cart/999", as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
