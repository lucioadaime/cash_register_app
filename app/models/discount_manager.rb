class DiscountManager
  def initialize
    @discounts = load_discounts
  end

  def load_discounts
    file_path = File.expand_path("../../data/discounts.json", __dir__)
    JSON.parse(File.read(file_path))
  end

  def calculate_discounted_price(product, quantity)
    discount = @discounts[product.code]
    if discount
      apply_discount(product, quantity, discount)
    else
      product.price * quantity
    end
  end

  def apply_discount(product, quantity, discount)
    case discount["type"]
    when "BOGO"
      items_bogo = quantity / 2
      (quantity - items_bogo) * product.price

    when "bulk price drop"
      if quantity >= discount["min_quantity"]
        quantity * discount["new_price"]
      else
        quantity * product.price
      end

    when "bulk drop by percentage"
      if quantity >= discount["min_quantity"]
        (quantity * discount["%_price"] * product.price * 100).ceil / 100.0
      else
        quantity * product.price
      end

    else
      quantity * product.price
    end
  end
end
