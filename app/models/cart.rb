class Cart
  attr_reader :products

  def initialize
    @items = {}
  end
  def empty?
    @items.empty? # This returns true if the cart has no items
  end

  def add_product(product_code)
    product_code = product_code.to_s.upcase
    product = Product.find_by_code(product_code)

    if product
      if @items[product]
        @items[product] += 1 # Increase the quantity if product exists in cart
      else
        @items[product] = 1 # Otherwise, add the product with quantity 1
      end
    else
      puts "Product with code #{product_code} not found."
    end
  end

  def remove_product(product_code)
    product_code = product_code.to_s.upcase

    # Find the product by its code
    product = @items.keys.find { |p| p.code == product_code }

    if product
      if @items[product] > 1
        @items[product] -= 1 # Decrease quantity
      else
        @items.delete(product) # Remove product from cart
      end
      true
    else
      false
    end
  end

  def total_price
    @items.sum(&:price)
  end

  # Display items in the cart
  def display_items
    @items.each do |product, quantity|
      puts "#{product.code}: #{product.name} - #{product.price} (Quantity: #{quantity})"
    end
  end
end
