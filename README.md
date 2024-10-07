# Cash Register App

A simple Cash Register application built with Ruby and Rails where a catalog of preloaded products can be added and removed from a cart, which can be viewed and checked out. On total price calculation, discounts are applied according to a file containing the relevant information. This app is designed to simulate the process of adding products to a shopping cart and applying discounts when checking out.

## Features

- Add products to the shopping cart using their unique product code.
- Remove products from the cart or reduce their quantity.
- View the cart's current contents.
- Calculate the total price of the cart, including discounts.
- Load preset products and discounts from a JSON file.
- Support for different discount rules based on the quantity or type of products.
- Test-Driven Development (TDD) using RSpec.
  

## Table of Contents

1. [Installation](#installation)
2. [Usage](#usage)
3. [Products](#products)
4. [Discounts](#discounts)
5. [Testing](#contributing)

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
   ruby main.rb
 ```

Now you can use the Cash Register app!
The menu is straightforward but here's an explanation:
  1. Add product: type in the code of any of the products displayed
  2. Remove product: if your cart is not empty and you want to remove a product using its code
  3. View cart: see what products you have in your cart
  4. Checkout: calculate the total amount to pay for the items in your cart. Once done, your cart is emptied!
  5. Exit : leave the app
