require_relative "../models/cart"
require_relative "../models/product"
require_relative "../views/cli_view"

class CashRegister
  def initialize(view)
    @cart = Cart.new
    @view = view
    puts "------------- \n Welcome to the Cash Register App \n-------------"
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
        show_cart(cart)
      when 4
        checkout(cart)
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
    cli_view = CLIView.new
    products = Product.preset_products
    cli_view.display_products(products)

    @view.display_message ( "Enter product code to add to cart:")
    input = gets.chomp.strip

    product = Product.find_by_code(input)

    if product
      cart.add_product(product.code)
      @view.display_message ( "#{product.name} added to cart.")
    else
      @view.display_message ("Product not found. Please try again.")
    end
  end

  def remove_product_from_cart(cart)
    unless cart.empty?
      @view.display_message ( "\nItems in your cart:")
      cart.display_items
      @view.display_message ( "Enter the code of the product you wish to remove:")
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

  def show_cart(cart)
    unless cart.empty?
      @view.display_message ( "\nItems in your cart:")
      cart.items.each do |product, info|
        @view.display_message ( "#{info[:product].code}: #{info[:product].name} - €#{info[:product].price} (Quantity: #{info[:quantity]})")
     end
    else
      @view.display_message("Cart is empty.")
    end
  end

  def checkout(cart)
    @view.display_message ( "\n--- Checkout ---")
    show_cart(cart)
    unless cart.empty?
      @view.display_message ( "The total is €#{cart.total_price}")
      cart.empty_cart
      @view.display_message ( "Thank you for shopping! \n")
    end
  end
end
