require "json"


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
    file_path = File.join(__dir__, "../../data/products.json") # Construct the path to the JSON file
    products_data = JSON.parse(File.read(file_path))
    @preset_products = products_data.map do |data|
      new(data["code"], data["name"], data["price"].to_f) # Ensure price is converted to float
    end
  end
end
