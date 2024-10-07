class CLIView
  def display_message(message)
    puts message
  end

  def display_welcome_message
    puts "Welcome to the Cash Register!"
  end

  def display_products(products)
    puts "\nAvailable Products:"
    products.each_with_index do |product, index|
      puts "#{index + 1}. #{product.code}: #{product.name} - €#{'%.2f' % product.price}"
    end
  end

  def display_menu
    puts "\nWhat would you like to do?"
    puts "1. Add product"
    puts "2. Remove product"
    puts "3. View cart"
    puts "4. Checkout"
    puts "5. Exit"
  end

  def get_choice
    print "Enter your choice: "
    gets.chomp.to_i
  end

  def get_product_name
    print "Enter the product name: "
    gets.chomp
  end

  def get_product_price
    print "Enter the product price: "
    gets.chomp.to_f
  end

  def get_product_name_to_remove
    print "Enter the product name to remove: "
    gets.chomp
  end
end
