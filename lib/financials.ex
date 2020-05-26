defmodule Financials do

  @two_decimal_precision 2
  @three_decimal_precision 3
  @four_decimal_precision 4
  @five_decimal_precision 5
  @six_decimal_precision 6

  @cash_decimal_precision 2



  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def net_income(total_revenues, total_expenses) do
    total_revenues - total_expenses
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def earnings(net_income, preferred_dividends) do
    net_income - preferred_dividends
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def retained_earnings(beginning_period_retained_earnings, net_income, cash_dividends, stock_dividends) do
    beginning_period_retained_earnings + net_income - cash_dividends - stock_dividends
  end

  # TODO: change_in_working_capital

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # operating cash flow
  def ocf(operating_income, depreciation, taxes, change_in_working_capital) do
    operating_income + depreciation - taxes + change_in_working_capital
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # return on revenue
  def ror(net_income, sales_revenue) do
    net_income/sales_revenue
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # return on sales
  def ros(operating_profit, net_sales) do
    operating_profit/net_sales
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # cost of goods sold
  def cogs(beginning_inventory, purchases, ending_inventory) do
    beginning_inventory + purchases - ending_inventory
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # earnings before interest and taxes
  def ebit(revenue, cogs, operating_expenses) do
    revenue - cogs - operating_expenses
  end

  # TODO: operating_expenses

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # earnings before interest, taxes, and amortization
  def ebita(revenue, cogs, operating_expenses, amortization) do
    revenue - cogs - (operating_expenses + amortization)
  end

  # TODO: amortization ?

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # earnings before interest, taxes, depreciation, and amortization
  def ebitda(net_income, interest_expense, taxes, depreciation, amortization) do
    net_income + interest_expense + taxes + depreciation + amortization
  end

  # TODO: net_credit_sales
  # TODO: average_accounts_receivable

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def receivable_turnover_ratio(net_credit_sales, average_accounts_receivable) do
    Float.round(net_credit_sales/average_accounts_receivable, @two_decimal_precision)
  end

  # TODO: accumulated_depreciation
  # TODO: total_fixed_assets

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def accumulated_depreciation_to_fixed_assets(accumulated_depreciation, total_fixed_assets) do
    Float.round(accumulated_depreciation/total_fixed_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def asset_coverage(total_assets, intangible_assets, current_liabilities, short_term_debt, total_debt) do
    Float.round(((total_assets - intangible_assets) - (current_liabilities - short_term_debt))/total_debt, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def asset_turnover(net_sales, average_total_sales) do
    Float.round(net_sales/average_total_sales, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def average_inventory_period(days, inventory_turnover) do
    Float.round(days/inventory_turnover, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def average_payment_period(average_accounts_payable, total_credit_purchases, days) do
    credit_days = Float.round(total_credit_purchases/days, @two_decimal_precision)
    Float.round(average_accounts_payable/credit_days, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def break_even_analysis(fixed_costs, sales_price_per_unit, variable_cost_per_unit) do
    Float.round(fixed_costs/(sales_price_per_unit - variable_cost_per_unit), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def capitalization_ratio(total_debt, shareholders_equity) do
    Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision)
  end

  # TODO: days_inventory_outstanding
  # TODO: days_sales_outstanding
  # TODO: days_payables_outstanding

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def cash_conversion_cycle(days_inventory_outstanding, days_sales_outstanding, days_payables_outstanding) do
    days_inventory_outstanding + days_sales_outstanding + days_payables_outstanding
  end


  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def cash_flow_coverage(operating_cash_flows, total_debt) do
    Float.round(operating_cash_flows/total_debt, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def cash_ratio(cash, cash_equivalents, total_current_liabilities) do
    Float.round((cash + cash_equivalents)/total_current_liabilities, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # compund annual growth rate
  def cagr(beginning_investment_value, ending_investment_value, years) do
    value_ratio = Float.round(beginning_investment_value/ending_investment_value, @two_decimal_precision)
    time_ratio = Float.round(1/years, @two_decimal_precision)
    :math.pow(value_ratio,time_ratio) - 1
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def contribution_margin(net_sales, variable_costs) do
    net_sales - variable_costs
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def current_ratio(current_assets, current_liabilities) do
    current_assets/current_liabilities
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # days payable outstanding
  def dpo(accounts_payable, cost_of_sales, days) do
    cost_of_sales_per_day = Float.round(cost_of_sales/days, @two_decimal_precision)
    Float.round(accounts_payable/cost_of_sales_per_day, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def days_sales_in_inventory(ending_inventory, cogs) do
    Float.round(ending_inventory/cogs, @two_decimal_precision) * 365
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def days_sales_outstanding(accounts_receivable, net_credit_sales) do
    Float.round(accounts_receivable/net_credit_sales, @two_decimal_precision) * 365
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def debt_ratio(total_liabilities, total_assets) do
    Float.round(total_liabilities/total_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # debt service coverage ratio
  def dscr(operating_income, total_debt_service_costs) do
    Float.round(operating_income/total_debt_service_costs, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def debt_to_asset(total_debt, total_assets) do
    Float.round(total_debt/total_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def debt_to_capital(total_debt, shareholders_equity) do
    Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def debt_to_equity(total_liabilities, total_equity) do
    Float.round(total_liabilities/total_equity, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # debt to income ratio
  def dti(total_monthly_debt_payments, gross_monthly_income) do
    Float.round(total_monthly_debt_payments/gross_monthly_income, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # defensive interval ratio
  def dir(defensive_assets, daily_operational_expenses) do
    Float.round(defensive_assets/daily_operational_expenses, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def eps_basic(earnings, shares_outstanding) do
    Float.round(earnings/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def eps_diluted(earnings, shares_outstanding, diluted_shares) do
    Float.round(earnings/(shares_outstanding + diluted_shares), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def eps_pro_forma(acquirers_net_income, targets_net_income, incremental_adjustments, shares_outstanding, diluted_shares) do
    Float.round((acquirers_net_income + targets_net_income + incremental_adjustments)/(shares_outstanding + diluted_shares), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def eps_book_value(total_equity, preferred_equity, shares_outstanding) do
    Float.round((total_equity - preferred_equity)/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def eps_retained(retained_earnings, shares_outstanding) do
    Float.round(retained_earnings/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def eps_cash(operating_cash_flow, shares_outstanding) do
    Float.round(operating_cash_flow/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def pe_ratio(price, earnings_per_share) do
    Float.round(price/earnings_per_share, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def peg_ratio(price_to_earnings, earnings_growth) do
    Float.round(price_to_earnings/earnings_growth, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def dividend_payout(net_dividends, net_income) do
    Float.round(net_dividends/net_income, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def dividend_yield(cash_dividends_per_share, market_value_per_share) do
    Float.round(cash_dividends_per_share/market_value_per_share, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def du_pont_analysis(profit_margin, total_asset_turnover, financial_leverage) do
    profit_margin * total_asset_turnover * financial_leverage
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # enterprise value
  def ev(market_capitalization, debt, current_cash) do
    market_capitalization + debt - current_cash
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def equity_multiplier(total_assets, total_stockholders_equity) do
    Float.round(total_assets/total_stockholders_equity, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def equity_ratio(total_equity, total_assets) do
    Float.round(total_equity/total_assets, @two_decimal_precision)
  end

  # TODO: add below to readme
  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def expense_ratio(operating_expenses, average_value_of_fund_assets) do
    Float.round(operating_expenses/average_value_of_fund_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  def fixed_asset_turnover_ratio(net_sales, fixed_assets, accumulated_depreciation) do
    Float.round(net_sales/(fixed_assets - accumulated_depreciation), @two_decimal_precision)
  end

  def fixed_charge_coverage_ratio(ebit, fixed_charges_before_taxes, interest) do
    Float.round((ebit + fixed_charges_before_taxes)/(fixed_charges_before_taxes + interest), @two_decimal_precision)
  end

  # free cash flow
  def fcf(operating_cash_flow, capital_expenditures) do
    operating_cash_flow - capital_expenditures
  end

  def goodwill_to_assets(goodwill, assets) do
    Float.round(goodwill/assets, @two_decimal_precision)
  end

  def gross_margin_ratio(gross_margin, net_sales) do
    Float.round(gross_margin/net_sales, @two_decimal_precision)
  end

  def gross_profit(total_sales, cogs) do
    total_sales - cogs
  end

  def interest_coverage_ratio(ebit, interest_expense) do
    Float.round(ebit/interest_expense, @two_decimal_precision)
  end

  # TODO: add XIRR wrapper

  def inventory_turnover_ratio(cogs, average_inventory) do
    Float.round(cogs/average_inventory, @two_decimal_precision)
  end

  # loan to value ratio
  def ltv(mortgage_amount, appraised_value_of_property) do
    Float.round(mortgage_amount/appraised_value_of_property, @two_decimal_precision)
  end

  def long_term_debt_to_total_asset_ratio(long_term_debt, total_assets) do
    Float.round(long_term_debt/total_assets, @two_decimal_precision)
  end

  def margin_of_safety_ratio(actual_sales, break_even_point) do
    actual_sales - break_even_point
  end

  def margin_of_safety_ratio(actual_sales, break_even_point) do
    Float.round((actual_sales - break_even_point)/actual_sales, @two_decimal_precision)
  end

  def margin_of_revenue(change_in_total_revenues, change_in_quantity_sold) do
    Float.round(change_in_total_revenues/change_in_quantity_sold, @two_decimal_precision)
  end









end