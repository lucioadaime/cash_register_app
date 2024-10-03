require_relative "controllers/cash_register"
require_relative "views/cli_view"

view = CLIView.new
cash_register = CashRegister.new(view)
cash_register.start
