# spec/models/product_spec.rb

require 'rspec'
require_relative '../../app/models/product'  # Adjust the path based on your project structure

RSpec.describe Product do
  describe '.preset_products' do
    it 'loads preset products correctly' do
      products = Product.preset_products

      expect(products).to be_an(Array)  # Check that it returns an array
      expect(products.size).to eq(3)     # Check that there are 3 preset products

      expect(products[0].code).to eq('GR1')
      expect(products[0].name).to eq('Green Tea')
      expect(products[0].price).to eq(3.11)

      expect(products[1].code).to eq('SR1')
      expect(products[1].name).to eq('Strawberries')
      expect(products[1].price).to eq(5.00)

      expect(products[2].code).to eq('CF1')
      expect(products[2].name).to eq('Coffee')
      expect(products[2].price).to eq(11.23)
    end
  end

  describe '.find_by_code' do
    before do
      Product.preset_products  # Load preset products before each test
    end

    it 'returns the correct product for a valid code' do
      product = Product.find_by_code('GR1')

      expect(product).to be_a(Product)
      expect(product.code).to eq('GR1')
      expect(product.name).to eq('Green Tea')
      expect(product.price).to eq(3.11)
    end

    it 'returns nil for an invalid code' do
      product = Product.find_by_code('INVALID_CODE')

      expect(product).to be_nil  # Should return nil for non-existing code
    end
  end

  describe '#initialize' do
    it 'initializes a product with the correct attributes' do
      product = Product.new('GR1', 'Green Tea', 3.11)

      expect(product.code).to eq('GR1')
      expect(product.name).to eq('Green Tea')
      expect(product.price).to eq(3.11)
    end
  end
end
