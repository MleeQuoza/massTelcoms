module ApplicationHelper
  def display_as_money(amount)
    number_to_currency(amount, unit: 'R ', precision: 2)
  end
end
