require "json"
require_relative "discount_manager"
class Cart
  attr_reader :items

  def initialize(discount_manager = DiscountManager.new)
    @items = {}
    @discount_manager = discount_manager
  end
  def empty?
    @items.empty? # This returns true if the cart has no items
  end

  def add_product(product_code)
    product_code = product_code.to_s.upcase
    product = Product.find_by_code(product_code)

    if product
      if @items[product.code] # Use product.code as the key
        @items[product.code][:quantity] += 1 # Increase the quantity
      else
        @items[product.code] = { product: product, quantity: 1 } # Add product with quantity
      end
    end
  end

  def remove_product(product_code)
    product_code = product_code.to_s.upcase

    # Find the product by its code
    product = Product.find_by_code(product_code)
    if product && @items[product_code] # product code exists and product is in cart
        if @items[product_code][:quantity] > 1
          @items[product_code][:quantity] -= 1 # Decrease quantity
        else
          @items.delete(product_code) # Remove product from cart
        end
        true
    else
      false
    end
  end


  def total_price
    total = 0.0
    # Decide whether a discount applies
    @items.each do |product_code, item|
        total += @discount_manager.calculate_discounted_price(item[:product], item[:quantity])
    end
    @items.sum { |product, info| info[:product].price * info[:quantity] }  # Calculate total price

    total
  end

  def empty_cart
    @items.each do |product, info|
      @items.delete(product)
    end
  end
end
