require "json"

class Cart
  attr_reader :items

  def initialize
    @items = {}
    @discounts = load_discounts
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

  def load_discounts
    file_path = File.expand_path("../../data/discounts.json", __dir__)
    JSON.parse(File.read(file_path))
  end

  def total_price
    total = 0.0
    # Decide whether a discount applies
    @items.each do |product_code, item|
      if @discounts[product_code]
        # If it applies we calculate the new value
        total += apply_discount(item[:product], item[:quantity], @discounts[product_code])
        # puts "Discount Applied!"
      else
        # Otherwise we calculate total regularly
        total += item[:product].price * item[:quantity]
      end
    end
    @items.sum { |product, info| info[:product].price * info[:quantity] }  # Calculate total price

    total
  end
def apply_discount(product, quantity,  discount)
  case discount["type"]
  # We apply the appropriate discount
  when "BOGO"
    items_bogo = quantity/2
    (quantity - items_bogo) * product.price

  when "bulk price drop"
    if quantity >= discount["min_quantity"]
      quantity * discount["new_price"]
    else
      quantity * product.price
    end
  when "bulk drop by percentage"
    if quantity >= discount["min_quantity"]
      (quantity * discount["%_price"] *  product.price * 100).ceil/100.0 # Rounding up the number to two decimal digits
    else
      quantity * product.price
    end
  else
    quantity * product.price
  end
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

  def empty_cart
    @items.each do |product, info|
      @items.delete(product)
    end
  end
end
