# Cash Register App

## Table of Contents

1. [Application Description](#description)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Testing](#testing)

## Description

A simple Cash Register application built with Ruby and Rails where a catalog of preloaded products can be added and removed from a cart, which can be viewed and checked out. On total price calculation, discounts are applied according to a file containing the relevant information. This app is designed to simulate the process of adding products to a shopping cart and applying discounts when checking out.

### Features

- Add products to the shopping cart using their unique product code.
- Remove products from the cart or reduce their quantity.
- View the cart's current contents.
- Calculate the total price of the cart, including discounts.
- Load preset products and discounts from a JSON file.
- Support for different discount rules based on the quantity or type of products.
- Test-Driven Development (TDD) using RSpec.

### Products
The available products are all loaded from a JSON file located in _/data/products.json_ where it can be edited to add new products to the shop!

| Product Code |  Name  | Price |
|:-----|:--------:|------:|
| GR1   | Green Tea | 3.11 € |
| SR1   |  Strawberries |  5.00 € |
| CF1   | Coffee |   11.23 € |


### Discounts
The available discounts are also loaded from a JSON file located in _/data/discounts.json_ where it can be edited to edit the current offers or add new ones with new rules!

- **Buy-One-Get-One-Free on Green Tea (GR1):** When a customer buys two Green Teas, only one is charged.
- **Bulk Discount on Strawberries (SR1):** When a customer buys 3 or more Strawberries, the price of each Strawberry drops from 5.00€ to 4.50€.
- **Coffee Discount on Coffee (CF1):** When a customer buys 3 or more Coffees, the price of each Coffee drops by 1/3, reducing the price from 11.23€ to approximately 7.49€.



## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/lucioadaime/cash_register_app.git
2. Navigate to the project directory and install required gemss:
3. ```bash
   cd cash_register_app
   bundle install

## Usage

1. To run the application type:
 ```bash
    cd app
   ruby main.rb
 ```

Now you can use the Cash Register app!
The menu is straightforward but here's an explanation:
  1. Add product: type in the code of any of the products displayed
  2. Remove product: if your cart is not empty and you want to remove a product using its code
  3. View cart: see what products you have in your cart
  4. Checkout: calculate the total amount to pay for the items in your cart. Once done, your cart is emptied!
  5. Exit : leave the app

### Example 
```bash
------------- 
 Welcome to the Cash Register App 
-------------

What would you like to do?
1. Add product
2. Remove product
3. View cart
4. Checkout
5. Exit
Enter your choice: 1

Available Products:
1. GR1: Green Tea - €3.11
2. SR1: Strawberries - €5.00
3. CF1: Coffee - €11.23
Enter product code to add to cart:
gr1
Green Tea added to cart.

What would you like to do?
1. Add product
2. Remove product
3. View cart
4. Checkout
5. Exit
Enter your choice: 1

Available Products:
1. GR1: Green Tea - €3.11
2. SR1: Strawberries - €5.00
3. CF1: Coffee - €11.23
Enter product code to add to cart:
gr1
Green Tea added to cart.

What would you like to do?
1. Add product
2. Remove product
3. View cart
4. Checkout
5. Exit
Enter your choice: 4

--- Checkout ---

Items in your cart:
GR1: Green Tea - €3.11 (Quantity: 2)
The total is €3.11
Thank you for shopping! 

What would you like to do?
1. Add product
2. Remove product
3. View cart
4. Checkout
5. Exit
Enter your choice: 5
Thank you for using the Cash Register!
 ```
## Testing

The application has been tested using RSpec. These tests include the process of adding items, removing them, checking out, calculating total prices for different combinations of items, etc.
To run such tests on the applications root folder execute the following command:
```bash
rspec
```
### Test Cases
- Adding Products to the Cart (#add_product):
    - Verifies that products are correctly added to the cart and that the quantity of the products is tracked.
   -  Ensures that adding the same product multiple times increments its quantity properly.
- Removing Products from the Cart (#remove_product):
    - Ensures that removing a product from the cart either decreases its quantity or removes it completely if the quantity reaches zero.
  -  Verifies that removing a product not present in the cart returns false.
- Calculating Total Price (#total_price):
  -  Validates that the total price of the cart is computed correctly based on the quantity and price of each product.
  -   Includes tests with multiple products to ensure correct summation of prices.
- Displaying Items (#display_items):
  -  Tests that the cart can display the list of products with their respective quantity and price.
  -  Ensures that an empty cart displays a message indicating no items.
- Discount Application:
  -  Tests different combinations of products in the cart to validate that discounts are applied correctly, such as the "buy one get one free" offer on green tea and the bulk discount for strawberries and coffee.
  -  These tests cover several edge cases, including adding various quantities of products, ensuring that all discounts are applied when necessary.
- Checking if Cart is Empty (#empty?):
  -  Tests the empty? method to verify that it returns true when the cart is empty and false when it contains products.
