class Cart
  attr_reader :items

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
      if @items[product.code] # Use product.code as the key
        @items[product.code][:quantity] += 1 # Increase the quantity
      else
        @items[product.code] = { product: product, quantity: 1 } # Add product with quantity
      end
    else
      puts "Product with code #{product_code} not found."
    end
  end

  def remove_product(product_code)
    product_code = product_code.to_s.upcase

    # Find the product by its code
    product = Product.find_by_code(product_code)
    if product
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
    puts "Current cart items: #{@items.inspect}"  # Debugging output

    @items.sum { |product, info| info[:product].price * info[:quantity] }  # Calculate total price
  end

  # Display items in the cart with quantity
  def display_items
    if empty?
      puts "The cart is empty."
    else
      @items.each do |product, info|
        puts "#{info[:product].code}: #{info[:product].name} - $#{info[:product].price} (Quantity: #{info[:quantity]})"
     end
    end
  end
end
