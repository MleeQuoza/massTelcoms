module DashboardHelper
  def unpaid_transactions_total(money_transactions)
    return nil unless money_transactions.present?
    sum = 0
    money_transactions.each{ |mt| sum += mt.amount }
    number_to_currency(sum, unit: 'R', precision: 2)
  end
end
