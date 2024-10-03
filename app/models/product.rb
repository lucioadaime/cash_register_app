class Product
  attr_reader :code, :name, :price
  # Class variable to store preset products
  @preset_products = []

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end
  def self.preset_products
    @preset_products.empty? ? load_preset_products : @preset_products
  end

  # Find a product by its code
  def self.find_by_code(code)
    code = code.to_s.upcase
    @preset_products.find { |product| product.code == code }
  end
  # Load preset products
  def self.load_preset_products
    @preset_products = [
      new("GR1", "Green Tea", 3.11),
      new("SR1", "Strawberries", 5.00),
      new("CF1", "Coffee", 11.23)
    ]
  end
end
