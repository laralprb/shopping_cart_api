require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    subject { build(:cart_product) }
    
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let(:cart_product) { build(:cart_product, cart: cart, product: product, quantity: 1) }

    context 'when saving' do
      it 'updates cart total' do
        expect(cart).to receive(:save)
        cart_product.save
      end
    end

    context 'when destroying' do
      before { cart_product.save! }

      it 'updates cart total' do
        expect(cart).to receive(:save)
        cart_product.destroy
      end
    end
  end
end
