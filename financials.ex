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