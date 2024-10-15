require 'rspec'
require_relative '../../app/models/cart'
require_relative '../../app/models/product'

RSpec.describe Cart do
  let(:green_tea) { Product.new('GR1', 'Green Tea', 3.11) }
  let(:strawberries) { Product.new('SR1', 'Strawberries', 5.00) }
  let(:coffee) { Product.new('CF1', 'Coffee', 11.23) }
  let(:cart) { Cart.new }
  products = Product.preset_products  # Ensure this returns an array


  describe '#add_product' do
    it 'adds a product to the cart with correct quantity' do
      expect(cart.items[green_tea.code]).to eq(nil) # Initially empty
      cart.add_product(green_tea.code)
      expect(cart.items[green_tea.code][:quantity]).to eq(1) # Check that the product quantity is 1
    end

    it 'increments the quantity if the same product is added again' do
      cart.add_product(green_tea.code)
      cart.add_product(green_tea.code)
      expect(cart.items[green_tea.code][:quantity]).to eq(2) # Check that the quantity increases
    end
  end

  describe '#remove_product' do
    it 'removes a product from the cart or reduces its quantity' do
      cart.add_product(green_tea.code)
      cart.add_product(green_tea.code)
      expect(cart.items[green_tea.code][:quantity]).to eq(2)

      cart.remove_product(green_tea.code) # Remove one item
      expect(cart.items[green_tea.code][:quantity]).to eq(1) # The quantity should now be 1

      cart.remove_product(green_tea.code) # Remove the last item
      expect(cart.items[green_tea.code]).to be_nil # The product should be removed from the cart
    end

    it 'returns false when trying to remove a product not in the cart' do
      result = cart.remove_product('NON_EXISTING_CODE')
      expect(result).to eq(false) # Should return false for non-existing products
    end
  end

  describe '#total_price' do
    it 'calculates the total price of products in the cart based on quantity' do
      cart.add_product(green_tea.code)
      cart.add_product(strawberries.code)
      cart.add_product(coffee.code) # Add a second Green Tea

      expect(cart.total_price).to eq(3.11 + 11.23 + 5.00)  # Total should be 3.11*2 + 5.00
    end
  end


  # Test total price at different points using the discounts and an extra item in total
  describe 'apply all discounts' do
    it 'GT1 SR1 SR1' do
      cart.add_product(green_tea.code) # €3.11
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code)
      # Total = 13.11
      expect(cart.total_price).to eq(13.11)
    end
    it 'GT1 SR1 SR1 SR1' do
      cart.add_product(green_tea.code) # €3.11
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code) # €13.5
      # Total = 16.61
      expect(cart.total_price).to eq(16.61)
    end
    it 'GT1 SR1 SR1 SR1 CF1' do
      cart.add_product(green_tea.code) # €3.11
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code) # €13.5
      cart.add_product(coffee.code) # €11.23
      # Total = 27.84
      expect(cart.total_price).to eq(27.84)
    end
    it 'GT1 SR1 SR1 SR1 CF1 GT1' do
      cart.add_product(green_tea.code) # €3.11
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code) # €13.5
      cart.add_product(coffee.code) # €11.23
      cart.add_product(green_tea.code) # €0 due to BOGO
      # Total = 27.84
      expect(cart.total_price).to eq(27.84)
    end
    it 'GT1 SR1 SR1 SR1 CF1 GT1 CF1 CF1 SR1' do
      cart.add_product(green_tea.code) # €3.11
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code)
      cart.add_product(strawberries.code) # €13.5
      cart.add_product(coffee.code) # €11.23
      cart.add_product(green_tea.code) # €0 due to BOGO
      cart.add_product(coffee.code)
      cart.add_product(coffee.code) # €11.23 due to bulk
      cart.add_product(strawberries.code) # €4.5
      # when checking out the total should be = 3.11 + 22.46 + 13.5 + 4.5 = 43.57
      expect(cart.total_price).to eq(43.57)
    end
  end

  describe '#empty?' do
    it 'returns true if the cart is empty' do
      expect(cart.empty?).to eq(true)
    end

    it 'returns false if the cart has products' do
      cart.add_product(green_tea.code)
      expect(cart.empty?).to eq(false)
    end
  end
end
