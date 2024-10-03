require_relative "../models/cart"
require_relative "../models/product"
require_relative "../views/cli_view"

class CashRegister
  def initialize(view)
    @cart = Cart.new
    @view = view
  end

  def start
    cli_view = CLIView.new
    products = Product.preset_products  # Ensure this returns an array
    cart = Cart.new
    loop do
      @view.display_menu
      choice = @view.get_choice

      case choice
      when 1
        add_product_to_cart(cart)
      when 2
        remove_product_from_cart(cart)
      when 3
        @view.display_message(cart)
      when 4
        checkout
      when 5
        @view.display_message("Thank you for using the Cash Register!")
        break
      else
        @view.display_message("Invalid choice. Please try again.")
      end
    end
  end

  private

  def add_product_to_cart(cart)
    puts "\n Available Products:"
    cli_view = CLIView.new
    products = Product.preset_products
    cli_view.display_products(products)

    puts "Enter product code to add to cart:"
    input = gets.chomp.strip

    product = Product.find_by_code(input)

    if product
      cart.add_product(product.code)
      puts "#{product.name} added to cart."
    else
      puts "Product not found. Please try again."
    end
  end

  def remove_product_from_cart(cart)
    unless cart.empty?
      puts "\nItems in your cart:"
      cart.display_items
      puts "Enter the code of the product you wish to remove:"
      input = gets.chomp.strip # Ensure input is captured correctly and whitespace is removed

      if product = Product.find_by_code(input)

        if cart.remove_product(product.code) # Assuming remove_product takes a Product object
          @view.display_message("#{product.name} has been removed from your cart.")
        else
          @view.display_message("Product not found in the cart.")
        end
      else
        @view.display_message("#{input} is not a valid product code.")
      end
    else
      @view.display_message("Cart is empty.")
    end
  end


  def checkout(cart)
    puts "\n--- Checkout ---"
    view_cart(cart)
    puts "Thank you for shopping!"
  end
end
