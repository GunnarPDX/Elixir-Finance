defmodule Financials do

  @two_decimal_precision 2

  def net_income(total_revenues, total_expenses) do
    total_revenues - total_expenses
  end

  ###-------------------------------------------------

  def earnings(net_income, preferred_dividends) do
    net_income - preferred_dividends
  end

  def retained_earnings(beginning_period_retained_earnings, net_income, cash_dividends, stock_dividends) do
    beginning_period_retained_earnings + net_income - cash_dividends - stock_dividends
  end

  # TODO: change_in_working_capital

  # operating cash flow
  def ocf(operating_income, depreciation, taxes, change_in_working_capital) do
    operating_income + depreciation - taxes + change_in_working_capital
  end

  # return on revenue
  def ror(net_income, sales_revenue) do
    net_income/sales_revenue
  end

  # return on sales
  def ros(operating_profit, net_sales) do
    operating_profit/net_sales
  end

  # cost of goods sold
  def cogs(beginning_inventory, purchases, ending_inventory) do
    beginning_inventory + purchases - ending_inventory
  end

  ###-------------------------------------------------

  # earnings before interest and taxes
  def ebit(revenue, cogs, operating_expenses) do
    revenue - cogs - operating_expenses
  end

  # TODO: operating_expenses

  # earnings before interest, taxes, and amortization
  def ebita(revenue, cogs, operating_expenses, amortization) do
    revenue - cogs - (operating_expenses + amortization)
  end

  # TODO: amortization ?

  # earnings before interest, taxes, depreciation, and amortization
  def ebitda(net_income, interest_expense, taxes, depreciation, amortization) do
    net_income + interest_expense + taxes + depreciation + amortization
  end

  ###-------------------------------------------------

  # TODO: net_credit_sales
  # TODO: average_accounts_receivable

  def receivable_turnover_ratio(net_credit_sales, average_accounts_receivable) do
    Float.round(net_credit_sales/average_accounts_receivable, @two_decimal_precision)
  end

  # TODO: accumulated_depreciation
  # TODO: total_fixed_assets

  def accumulated_depreciation_to_fixed_assets(accumulated_depreciation, total_fixed_assets) do
    Float.round(accumulated_depreciation/total_fixed_assets, @two_decimal_precision)
  end

  def asset_coverage(total_assets, intangible_assets, current_liabilities, short_term_debt, total_debt) do
    Float.round(((total_assets - intangible_assets) - (current_liabilities - short_term_debt))/total_debt, @two_decimal_precision)
  end

  def asset_turnover(net_sales, average_total_sales) do
    Float.round(net_sales/average_total_sales, @two_decimal_precision)
  end

  ###-------------------------------------------------

  def average_inventory_period(days, inventory_turnover) do
    Float.round(days/inventory_turnover, @two_decimal_precision)
  end

  def average_payment_period(average_accounts_payable, total_credit_purchases, days) do
    credit_days = Float.round(total_credit_purchases/days, @two_decimal_precision)
    Float.round(average_accounts_payable/credit_days, @two_decimal_precision)
  end

  ###-------------------------------------------------

  def break_even_analysis(fixed_costs, sales_price_per_unit, variable_cost_per_unit) do
    Float.round(fixed_costs/(sales_price_per_unit - variable_cost_per_unit), @two_decimal_precision)
  end

  ###-------------------------------------------------

  def capitalization_ratio(total_debt, shareholders_equity) do
    Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision)
  end

  ###-------------------------------------------------

  # TODO: days_inventory_outstanding
  # TODO: days_sales_outstanding
  # TODO: days_payables_outstanding

  def cash_conversion_cycle(days_inventory_outstanding, days_sales_outstanding, days_payables_outstanding) do
    days_inventory_outstanding + days_sales_outstanding + days_payables_outstanding
  end

  ###-------------------------------------------------

  def cash_flow_coverage(operating_cash_flows, total_debt) do
    Float.round(operating_cash_flows/total_debt, @two_decimal_precision)
  end

  def cash_ratio(cash, cash_equivalents, total_current_liabilities) do
    Float.round((cash + cash_equivalents)/total_current_liabilities, @two_decimal_precision)
  end

  ###-------------------------------------------------

  # compund annual growth rate
  def cagr(beginning_investment_value, ending_investment_value, years) do
    value_ratio = Float.round(beginning_investment_value/ending_investment_value, @two_decimal_precision)
    time_ratio = Float.round(1/years, @two_decimal_precision)
    :math.pow(value_ratio,time_ratio) - 1
  end

  ###-------------------------------------------------

  def contribution_margin(net_sales, variable_costs) do
    net_sales - variable_costs
  end

  ###-------------------------------------------------

  def current_ratio(current_assets, current_liabilities) do
    current_assets/current_liabilities
  end

  # days payable outstanding
  def dpo(accounts_payable, cost_of_sales, days) do
    cost_of_sales_per_day = Float.round(cost_of_sales/days, @two_decimal_precision)
    Float.round(accounts_payable/cost_of_sales_per_day, @two_decimal_precision)
  end

  def days_sales_in_inventory(ending_inventory, cogs) do
    Float.round(ending_inventory/cogs, @two_decimal_precision) * 365
  end

  def days_sales_outstanding(accounts_receivable, net_credit_sales) do
    Float.round(accounts_receivable/net_credit_sales, @two_decimal_precision) * 365
  end

  ###-------------------------------------------------

  def debt_ratio(total_liabilities, total_assets) do
    Float.round(total_liabilities/total_assets, @two_decimal_precision)
  end

  # debt service coverage ratio
  def dscr(operating_income, total_debt_service_costs) do
    Float.round(operating_income/total_debt_service_costs, @two_decimal_precision)
  end

  def debt_to_asset(total_debt, total_assets) do
    Float.round(total_debt/total_assets, @two_decimal_precision)
  end

  def debt_to_capital(total_debt, shareholders_equity) do
    Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision)
  end

  def debt_to_equity(total_liabilities, total_equity) do
    Float.round(total_liabilities/total_equity, @two_decimal_precision)
  end

  # debt to income ratio
  def dti(total_monthly_debt_payments, gross_monthly_income) do
    Float.round(total_monthly_debt_payments/gross_monthly_income, @two_decimal_precision)
  end

  ###-------------------------------------------------

  # defensive interval ratio
  def dir(defensive_assets, daily_operational_expenses) do
    Float.round(defensive_assets/daily_operational_expenses, @two_decimal_precision)
  end

  ###-------------------------------------------------

  def eps_basic(earnings, shares_outstanding) do
    Float.round(earnings/shares_outstanding, @two_decimal_precision)
  end

  def eps_diluted(earnings, shares_outstanding, diluted_shares) do
    Float.round(earnings/(shares_outstanding + diluted_shares), @two_decimal_precision)
  end

  def eps_pro_forma(acquirers_net_income, targets_net_income, incremental_adjustments, shares_outstanding, diluted_shares) do
    Float.round((acquirers_net_income + targets_net_income + incremental_adjustments)/(shares_outstanding + diluted_shares), @two_decimal_precision)
  end

  def eps_book_value(total_equity, preferred_equity, shares_outstanding) do
    Float.round((total_equity - preferred_equity)/shares_outstanding, @two_decimal_precision)
  end

  def eps_retained(retained_earnings, shares_outstanding) do
    Float.round(retained_earnings/shares_outstanding, @two_decimal_precision)
  end

  def eps_cash(operating_cash_flow, shares_outstanding) do
    Float.round(operating_cash_flow/shares_outstanding, @two_decimal_precision)
  end

  ###-------------------------------------------------

  def pe_ratio(price, earnings_per_share) do
    Float.round(price/earnings_per_share, @two_decimal_precision)
  end

  ###-------------------------------------------------

  def peg_ratio(price_to_earnings, earnings_growth) do
    Float.round(price_to_earnings/earnings_growth, @two_decimal_precision)
  end

  ###-------------------------------------------------



end