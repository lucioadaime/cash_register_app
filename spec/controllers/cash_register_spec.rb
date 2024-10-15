require 'rspec'

require_relative '../../app/controllers/cash_register'
require_relative '../../app/models/cart'
require_relative '../../app/models/product'
require_relative '../../app/views/cli_view'

RSpec.describe CashRegister do
  let(:view) { CLIView.new } # Mock or stub CLIView for testing
  let(:cart) { Cart.new }
  let(:cash_register) { CashRegister.new(view) }
  let(:green_tea) { Product.new('GR1', 'Green Tea', 3.11) }
  let(:strawberries) { Product.new('SR1', 'Strawberries', 5.00) }
  let(:coffee) { Product.new('CF1', 'Coffee', 11.23) }

  # we simulate a cart that can be displayed
  describe '#initialize' do
    it 'initializes with a new cart and view' do
      expect(cash_register.instance_variable_get(:@cart)).to be_a(Cart)
      expect(cash_register.instance_variable_get(:@view)).to eq(view)
    end
  end

  # we simulate exiting
  describe '#start' do
    it 'displays the menu and responds to user choices' do
      allow(view).to receive(:display_menu)
      allow(view).to receive(:get_choice).and_return(5)  # simulate exit
      expect(view).to receive(:display_menu)
      expect(view).to receive(:get_choice).and_return(5)
      expect(view).to receive(:display_message).with("Thank you for using the Cash Register!")

      cash_register.start
    end
  end

  # we simulate adding products
  describe '#add_product_to_cart' do
  before do
    allow(Product).to receive(:preset_products).and_return([ green_tea, strawberries, coffee ])
    allow(view).to receive(:display_products)
  end

  # Green Tea for example
  it 'adds a product to the cart if the product code is valid' do
    expect(view).to receive(:display_message).with("Enter product code to add to cart:")
    allow(cash_register).to receive(:gets).and_return('GR1')
    expect(view).to receive(:display_message).with("Green Tea added to cart.")
    expect(cart.items[green_tea.code]).to eq(nil)
    cash_register.send(:add_product_to_cart, cart)
    expect(cart.items[green_tea.code][:quantity]).to eq(1)
  end

  # What if its the wrong product code?
  it 'displays an error message if the product code is invalid' do
    expect(view).to receive(:display_message).with("Enter product code to add to cart:")
    allow(cash_register).to receive(:gets).and_return('INVALID_CODE')
    expect(view).to receive(:display_message).with("Product not found. Please try again.")

    cash_register.send(:add_product_to_cart, cart)
  end
end
# Removing one product from cart
describe '#remove_product_from_cart' do
  before do
    allow(Product).to receive(:preset_products).and_return([ green_tea, strawberries, coffee ])
    cart.add_product(green_tea.code)
    cart.add_product(green_tea.code)
  end
  # Removing GR1 when its present
  it 'removes a product from the cart if the product code is valid' do
    expect(view).to receive(:display_message).with("\nItems in your cart:")
    expect(view).to receive(:display_message).with("GR1: Green Tea - €3.11 (Quantity: 2)")
    expect(view).to receive(:display_message).with("Enter the code of the product you wish to remove:")
    allow(cash_register).to receive(:gets).and_return('GR1')
    expect(view).to receive(:display_message).with("Green Tea has been removed from your cart.")

    cash_register.send(:remove_product_from_cart, cart)
    expect(cart.items[green_tea.code][:quantity]).to eq(1)  # One item should remain
  end
  # Removing SR1 when its not in the cart
  it 'displays an error message if the product code is not in the cart' do
    expect(view).to receive(:display_message).with("\nItems in your cart:")
    expect(view).to receive(:display_message).with("GR1: Green Tea - €3.11 (Quantity: 2)")
    expect(view).to receive(:display_message).with("Enter the code of the product you wish to remove:")
    allow(cash_register).to receive(:gets).and_return('SR1')
    expect(view).to receive(:display_message).with("Product not found in the cart.")

    cash_register.send(:remove_product_from_cart, cart)
  end
  # Removing an inexistent product
  it 'displays an error message if the product code is invalid' do
    expect(view).to receive(:display_message).with("\nItems in your cart:")
    expect(view).to receive(:display_message).with("GR1: Green Tea - €3.11 (Quantity: 2)")
    expect(view).to receive(:display_message).with("Enter the code of the product you wish to remove:")
    allow(cash_register).to receive(:gets).and_return('INVALID_CODE')
    expect(view).to receive(:display_message).with("INVALID_CODE is not a valid product code.")

    cash_register.send(:remove_product_from_cart, cart)
  end
end

# Shwoing cart
describe '#show_cart' do
  before do
      allow(view).to receive(:display_menu)
      allow(view).to receive(:get_choice).and_return(3)  # simulate show cart
  end
  # Cart is not empty
  it 'displays the cart items' do
    cart.add_product(green_tea.code)
    cart.add_product(strawberries.code)
    expect { cash_register.send(:show_cart, cart) }.to output(
      "------------- \n Welcome to the Cash Register App \n-------------\n\nItems in your cart:\nGR1: Green Tea - €3.11 (Quantity: 1)\nSR1: Strawberries - €5.0 (Quantity: 1)\n"
    ).to_stdout
  end
  # Cart is empty
  it 'displays a message if the cart is empty' do
    expect(view).to receive(:display_message).with("Cart is empty.")
    cash_register.send(:show_cart, cart)
  end
end

  # Checkout when we have products vs empty cart
  describe '#checkout' do
    before do
      allow(Product).to receive(:preset_products).and_return([ green_tea, strawberries, coffee ])
      cart.add_product(green_tea.code)
      cart.add_product(strawberries.code)
    end

    it 'displays the total price and empties the cart' do
      expect(cart).to receive(:empty_cart)
      expect { cash_register.send(:checkout, cart) }.to output(
        "------------- \n Welcome to the Cash Register App \n-------------\n\n--- Checkout ---\n\nItems in your cart:\nGR1: Green Tea - €3.11 (Quantity: 1)\nSR1: Strawberries - €5.0 (Quantity: 1)\nThe total is €8.11\nThank you for shopping! \n"
      ).to_stdout
    end
    # Empty cart
    it 'displays a message if the cart is empty' do
      cart.empty_cart
      expect(view).to receive(:display_message).with("\n--- Checkout ---")
      expect(view).to receive(:display_message).with("Cart is empty.")
      cash_register.send(:checkout, cart)
    end
  end
end





=begin

# Shwoing cart
describe '#show_cart' do
  # Cart is not empty
  it 'displays the cart items' do
    cart.add_product(green_tea.code)
    cart.add_product(strawberries.code)

    expect { cash_register.send(:show_cart, cart) }.to output(
      "\nItems in your cart:\nGR1: Green Tea - €3.11 (Quantity: 1)\nSR1: Strawberries - €5.0 (Quantity: 1)\n"
    ).to_stdout
  end
  # Cart is empty
  it 'displays a message if the cart is empty' do
    expect(view).to receive(:display_message).with("Cart is empty.")
    cash_register.send(:show_cart, cart)
  end
end

# Checkout when we have products vs empty cart
describe '#checkout' do
  before do
    allow(Product).to receive(:preset_products).and_return([ green_tea, strawberries, coffee ])
    cart.add_product(green_tea.code)
    cart.add_product(strawberries.code)
  end

  it 'displays the total price and empties the cart' do
    expect(cart).to receive(:empty_cart)
    expect { cash_register.send(:checkout, cart) }.to output(
      "\n--- Checkout ---\nItems in your cart:\nGR1: Green Tea - €3.11 (Quantity: 1)\nSR1: Strawberries - €5.0 (Quantity: 1)\nThe total is €8.11\nThank you for shopping! \n"
    ).to_stdout
  end
  # Empty cart
  it 'displays a message if the cart is empty' do
    cart.empty_cart
    expect(view).to receive(:display_message).with("Cart is empty.")
    cash_register.send(:checkout, cart)
  end
end
end
=end
