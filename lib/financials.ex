defmodule Financials do

  @two_decimal_precision 2
  @three_decimal_precision 3
  @four_decimal_precision 4
  @five_decimal_precision 5
  @six_decimal_precision 6

  @cash_decimal_precision 2



  ##--------------------------------------------------------------
  ## Net Income Calculation
  ## @param float -- total_revenues
  ## @param float -- total_expenses
  ## @return float
  ##--------------------------------------------------------------
  def net_income(total_revenues, total_expenses) do
    total_revenues - total_expenses
  end

  ##--------------------------------------------------------------
  ## Net Earnings Calculation
  ## @param float -- net_income
  ## @param float -- preferred_dividends
  ## @return float
  ##--------------------------------------------------------------
  def earnings(net_income, preferred_dividends) do
    net_income - preferred_dividends
  end

  ##--------------------------------------------------------------
  ## Retained Earnings Calculation
  ## @param float -- beginning_period_retained_earnings
  ## @param float -- net_income
  ## @param float -- cash_dividends
  ## @param float -- stock_dividends
  ## @return float
  ##--------------------------------------------------------------
  def retained_earnings(beginning_period_retained_earnings, net_income, cash_dividends, stock_dividends) do
    beginning_period_retained_earnings + net_income - cash_dividends - stock_dividends
  end

  # TODO: change_in_working_capital

  ##--------------------------------------------------------------
  ## Operating Cash Flow Calculation
  ## @param float -- operating_income
  ## @param float -- depreciation
  ## @param float -- taxes
  ## @param float -- change_in_working_capital
  ## @return float
  ##--------------------------------------------------------------
  def ocf(operating_income, depreciation, taxes, change_in_working_capital) do
    operating_income + depreciation - taxes + change_in_working_capital
  end

  ##--------------------------------------------------------------
  ## Return on Revenue Calculation
  ## @param float -- net_income
  ## @param float -- sales_revenue
  ## @return float
  ##--------------------------------------------------------------
  def ror(net_income, sales_revenue) do
    net_income/sales_revenue
  end

  ##--------------------------------------------------------------
  ## Return on Sales Calculation
  ## @param float -- operating_profit
  ## @param float -- net_sales
  ## @return float
  ##--------------------------------------------------------------
  def ros(operating_profit, net_sales) do
    operating_profit/net_sales
  end

  ##--------------------------------------------------------------
  ## Cost of Goods Sold Calculation
  ## @param float -- beginning_inventory
  ## @param float -- purchases
  ## @param float -- ending_inventory
  ## @return float
  ##--------------------------------------------------------------
  def cogs(beginning_inventory, purchases, ending_inventory) do
    beginning_inventory + purchases - ending_inventory
  end

  ##--------------------------------------------------------------
  ## EBIT -- Earnings Before Interest and Taxes Calculation
  ## @param float -- revenue
  ## @param float -- cogs
  ## @param float -- operating_expenses
  ## @return float
  ##--------------------------------------------------------------
  def ebit(revenue, cogs, operating_expenses) do
    revenue - cogs - operating_expenses
  end

  # TODO: operating_expenses

  ##--------------------------------------------------------------
  ## EBITA -- Earnings Before Interest, Taxes, and Amortization Calculation
  ## @param float -- revenue
  ## @param float -- cogs
  ## @param float -- operating_expenses
  ## @param float -- amortization
  ## @return float
  ##--------------------------------------------------------------
  def ebita(revenue, cogs, operating_expenses, amortization) do
    revenue - cogs - (operating_expenses + amortization)
  end

  # TODO: amortization ?

  ##--------------------------------------------------------------
  ## EBITDA -- Earnings Before Interest, Taxes, Depreciation and Amortization Calculation
  ## @param float -- net_income
  ## @param float -- interest_expense
  ## @param float -- taxes
  ## @param float -- depreciation
  ## @param float -- amortization
  ## @return float
  ##--------------------------------------------------------------
  def ebitda(net_income, interest_expense, taxes, depreciation, amortization) do
    net_income + interest_expense + taxes + depreciation + amortization
  end

  # TODO: net_credit_sales
  # TODO: average_accounts_receivable

  ##--------------------------------------------------------------
  ## Receivable Turnover Ratio Calculation
  ## @param float -- net_credit_sales
  ## @param float -- average_accounts_receivable
  ## @return float
  ##--------------------------------------------------------------
  def receivable_turnover_ratio(net_credit_sales, average_accounts_receivable) do
    Float.round(net_credit_sales/average_accounts_receivable, @two_decimal_precision)
  end

  # TODO: accumulated_depreciation
  # TODO: total_fixed_assets

  ##--------------------------------------------------------------
  ## Accumulated Depreciation to Fixed Assets Calculation
  ## @param float -- accumulated_depreciation
  ## @param float -- total_fixed_assets
  ## @return float
  ##--------------------------------------------------------------
  def accumulated_depreciation_to_fixed_assets(accumulated_depreciation, total_fixed_assets) do
    Float.round(accumulated_depreciation/total_fixed_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Asset Coverage Ratio Calculation
  ## @param float -- total_assets
  ## @param float -- intangible_assets
  ## @param float -- current_liabilities
  ## @param float -- short_term_debt
  ## @param float -- total_debt
  ## @return float
  ##--------------------------------------------------------------
  def asset_coverage(total_assets, intangible_assets, current_liabilities, short_term_debt, total_debt) do
    Float.round(((total_assets - intangible_assets) - (current_liabilities - short_term_debt))/total_debt, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Asset Turnover Ratio Calculation
  ## @param float -- net_sales
  ## @param float -- average_total_sales
  ## @return float
  ##--------------------------------------------------------------
  def asset_turnover(net_sales, average_total_sales) do
    Float.round(net_sales/average_total_sales, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Average Inventory Period Calculation
  ## @param int -- days
  ## @param float -- inventory_turnover
  ## @return float
  ##--------------------------------------------------------------
  def average_inventory_period(days, inventory_turnover) do
    Float.round(days/inventory_turnover, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Average Payment Period Calculation
  ## @param float -- average_accounts_payable
  ## @param float -- total_credit_purchases
  ## @param int -- days
  ## @return float
  ##--------------------------------------------------------------
  def average_payment_period(average_accounts_payable, total_credit_purchases, days) do
    credit_days = Float.round(total_credit_purchases/days, @two_decimal_precision)
    Float.round(average_accounts_payable/credit_days, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Break Even Analysis Calculation
  ## @param float -- fixed_costs
  ## @param float -- sales_price_per_unit
  ## @param float -- variable_cost_per_unit
  ## @return float
  ##--------------------------------------------------------------
  def break_even_analysis(fixed_costs, sales_price_per_unit, variable_cost_per_unit) do
    Float.round(fixed_costs/(sales_price_per_unit - variable_cost_per_unit), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Capitalization Ratio Calculation
  ## @param float -- total_debt
  ## @param float -- shareholders_equity
  ## @return float
  ##--------------------------------------------------------------
  def capitalization_ratio(total_debt, shareholders_equity) do
    Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision)
  end

  # TODO: days_inventory_outstanding
  # TODO: days_sales_outstanding
  # TODO: days_payables_outstanding

  ##--------------------------------------------------------------
  ## Cash Conversion Cycle Calculation
  ## @param float -- days_inventory_outstanding
  ## @param float --  days_sales_outstanding
  ## @param float -- days_payables_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def cash_conversion_cycle(days_inventory_outstanding, days_sales_outstanding, days_payables_outstanding) do
    days_inventory_outstanding + days_sales_outstanding + days_payables_outstanding
  end


  ##--------------------------------------------------------------
  ## Cash Flow Coverage Ratio Calculation
  ## @param float -- operating_cash_flows
  ## @param float -- total_debt
  ## @return float
  ##--------------------------------------------------------------
  def cash_flow_coverage(operating_cash_flows, total_debt) do
    Float.round(operating_cash_flows/total_debt, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Cash Ratio Calculation
  ## @param float -- cash
  ## @param float -- cash_equivalents
  ## @param float -- total_current_liabilities
  ## @return float
  ##--------------------------------------------------------------
  def cash_ratio(cash, cash_equivalents, total_current_liabilities) do
    Float.round((cash + cash_equivalents)/total_current_liabilities, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Compound Annual Growth Rate Calculation
  ## @param float -- beginning_investment_value
  ## @param float -- ending_investment_value
  ## @param int -- years
  ## @return float
  ##--------------------------------------------------------------
  def cagr(beginning_investment_value, ending_investment_value, years) do
    value_ratio = Float.round(ending_investment_value/beginning_investment_value, @two_decimal_precision)
    time_ratio = Float.round(1/years, @two_decimal_precision)
    :math.pow(value_ratio,time_ratio) - 1
  end

  ##--------------------------------------------------------------
  ## Contribution Margin Calculation
  ## @param float -- net_sales
  ## @param float -- variable_costs
  ## @return float
  ##--------------------------------------------------------------
  def contribution_margin(net_sales, variable_costs) do
    net_sales - variable_costs
  end

  ##--------------------------------------------------------------
  ## Current Ratio Calculation
  ## @param float -- current_assets
  ## @param float -- current_liabilities
  ## @return float
  ##--------------------------------------------------------------
  def current_ratio(current_assets, current_liabilities) do
    current_assets/current_liabilities
  end

  ##--------------------------------------------------------------
  ## Days Payable Outstanding Calculation
  ## @param float -- accounts_payable
  ## @param float -- cost_of_sales
  ## @param int -- days
  ## @return float
  ##--------------------------------------------------------------
  def dpo(accounts_payable, cost_of_sales, days) do
    cost_of_sales_per_day = Float.round(cost_of_sales/days, @two_decimal_precision)
    Float.round(accounts_payable/cost_of_sales_per_day, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Days Sales in Inventory Calculation
  ## @param float -- ending_inventory
  ## @param float -- cogs
  ## @return float
  ##--------------------------------------------------------------
  def days_sales_in_inventory(ending_inventory, cogs) do
    Float.round(ending_inventory/cogs, @two_decimal_precision) * 365
  end

  ##--------------------------------------------------------------
  ## Days Sales Outstanding Calculation
  ## @param float -- accounts_receivable
  ## @param float -- net_credit_sales
  ## @return float
  ##--------------------------------------------------------------
  def days_sales_outstanding(accounts_receivable, net_credit_sales) do
    Float.round(accounts_receivable/net_credit_sales, @two_decimal_precision) * 365
  end

  ##--------------------------------------------------------------
  ## Debt Ratio Calculation
  ## @param float -- total_liabilities
  ## @param float -- total_assets
  ## @return float
  ##--------------------------------------------------------------
  def debt_ratio(total_liabilities, total_assets) do
    Float.round(total_liabilities/total_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Debt Service Coverage Ratio
  ## @param float -- operating_income
  ## @param float -- total_debt_service_costs
  ## @return float
  ##--------------------------------------------------------------
  def dscr(operating_income, total_debt_service_costs) do
    Float.round(operating_income/total_debt_service_costs, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Debt to Asset Ratio Calculation
  ## @param float -- total_debt
  ## @param float -- total_assets
  ## @return float
  ##--------------------------------------------------------------
  def debt_to_asset(total_debt, total_assets) do
    Float.round(total_debt/total_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Debt ot Capital Ratio Calculation
  ## @param float -- total_debt
  ## @param float -- shareholders_equity
  ## @return float
  ##--------------------------------------------------------------
  def debt_to_capital(total_debt, shareholders_equity) do
    Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Debt to Equity Ratio Calculation
  ## @param float -- total_liabilities
  ## @param float -- total_equity
  ## @return float
  ##--------------------------------------------------------------
  def debt_to_equity(total_liabilities, total_equity) do
    Float.round(total_liabilities/total_equity, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Debt to Income Ratio Calculation
  ## @param float -- total_monthly_debt_payments
  ## @param float -- gross_monthly_income
  ## @return float
  ##--------------------------------------------------------------
  def dti(total_monthly_debt_payments, gross_monthly_income) do
    Float.round(total_monthly_debt_payments/gross_monthly_income, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Defensive Interval Ratio Calculation
  ## @param float -- defensive_assets
  ## @param float -- daily_operational_expenses
  ## @return float
  ##--------------------------------------------------------------
  def dir(defensive_assets, daily_operational_expenses) do
    Float.round(defensive_assets/daily_operational_expenses, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Basic Earnings Per Share Calculation
  ## @param float -- earnings
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_basic(earnings, shares_outstanding) do
    Float.round(earnings/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Diluted Earnings Per Share Calculation
  ## @param float -- earnings
  ## @param float -- shares_outstanding
  ## @param float -- diluted_shares
  ## @return float
  ##--------------------------------------------------------------
  def eps_diluted(earnings, shares_outstanding, diluted_shares) do
    Float.round(earnings/(shares_outstanding + diluted_shares), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Pro Forma Earnings Per Share Calculation
  ## @param float -- acquirers_net_income
  ## @param float -- targets_net_income
  ## @param float -- incremental_adjustments
  ## @param float -- shares_outstanding
  ## @param float -- diluted_shares
  ## @return float
  ##--------------------------------------------------------------
  def eps_pro_forma(acquirers_net_income, targets_net_income, incremental_adjustments, shares_outstanding, diluted_shares) do
    Float.round((acquirers_net_income + targets_net_income + incremental_adjustments)/(shares_outstanding + diluted_shares), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Book Value Earnings Per Share Calculation
  ## @param float -- total_equity
  ## @param float -- preferred_equity
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_book_value(total_equity, preferred_equity, shares_outstanding) do
    Float.round((total_equity - preferred_equity)/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Retained Earnings Per Share Calculation
  ## @param float -- retained_earnings
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_retained(retained_earnings, shares_outstanding) do
    Float.round(retained_earnings/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Cash Earnings Per Share Calculation
  ## @param float -- operating_cash_flow
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_cash(operating_cash_flow, shares_outstanding) do
    Float.round(operating_cash_flow/shares_outstanding, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Price to Earnings Ratio Calculation
  ## @param float -- price
  ## @param float -- earnings_per_share
  ## @return float
  ##--------------------------------------------------------------
  def pe_ratio(price, earnings_per_share) do
    Float.round(price/earnings_per_share, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Price to Earnings to Growth Ratio Calculation
  ## @param float -- price_to_earnings
  ## @param float -- earnings_growth
  ## @return float
  ##--------------------------------------------------------------
  def peg_ratio(price_to_earnings, earnings_growth) do
    Float.round(price_to_earnings/earnings_growth, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Dividend Payout Calculation
  ## @param float -- net_dividends
  ## @param float -- net_income
  ## @return float
  ##--------------------------------------------------------------
  def dividend_payout(net_dividends, net_income) do
    Float.round(net_dividends/net_income, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Dividend Yield Calculation
  ## @param float -- cash_dividends_per_share
  ## @param float -- market_value_per_share
  ## @return float
  ##--------------------------------------------------------------
  def dividend_yield(cash_dividends_per_share, market_value_per_share) do
    Float.round(cash_dividends_per_share/market_value_per_share, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## DuPont Analysis Calculation
  ## @param float -- profit_margin
  ## @param float -- total_asset_turnover
  ## @param float -- financial_leverage
  ## @return float
  ##--------------------------------------------------------------
  def du_pont_analysis(profit_margin, total_asset_turnover, financial_leverage) do
    profit_margin * total_asset_turnover * financial_leverage
  end

  ##--------------------------------------------------------------
  ## Enterprise Value Calculation
  ## @param float -- market_capitalization
  ## @param float -- debt
  ## @param float -- current_cash
  ## @return float
  ##--------------------------------------------------------------
  # enterprise value
  def ev(market_capitalization, debt, current_cash) do
    market_capitalization + debt - current_cash
  end

  ##--------------------------------------------------------------
  ## Equity Multiplier Calculation
  ## @param float -- total_assets
  ## @param float -- total_stockholders_equity
  ## @return float
  ##--------------------------------------------------------------
  def equity_multiplier(total_assets, total_stockholders_equity) do
    Float.round(total_assets/total_stockholders_equity, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Equity Ratio Calculation
  ## @param float -- total_equity
  ## @param float -- total_assets
  ## @return float
  ##--------------------------------------------------------------
  def equity_ratio(total_equity, total_assets) do
    Float.round(total_equity/total_assets, @two_decimal_precision)
  end

  # TODO: add below to readme

  ##--------------------------------------------------------------
  ## Expense Ratio Calculation
  ## @param float -- operating_expenses
  ## @param float -- average_value_of_fund_assets
  ## @return float
  ##--------------------------------------------------------------
  def expense_ratio(operating_expenses, average_value_of_fund_assets) do
    Float.round(operating_expenses/average_value_of_fund_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Fixed Asset Turnover Ratio
  ## @param float -- net_sales
  ## @param float -- fixed_assets
  ## @param float -- accumulated_depreciation
  ## @return float
  ##--------------------------------------------------------------
  def fixed_asset_turnover_ratio(net_sales, fixed_assets, accumulated_depreciation) do
    Float.round(net_sales/(fixed_assets - accumulated_depreciation), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Fixed Charge Coverage Ratio
  ## @param float -- ebit
  ## @param float -- fixed_charges_before_taxes
  ## @param float -- interest
  ## @return float
  ##--------------------------------------------------------------
  def fixed_charge_coverage_ratio(ebit, fixed_charges_before_taxes, interest) do
    Float.round((ebit + fixed_charges_before_taxes)/(fixed_charges_before_taxes + interest), @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Free Cash Flow Calculation
  ## @param float -- operating_cash_flow
  ## @param float -- capital_expenditures
  ## @return float
  ##--------------------------------------------------------------
  def fcf(operating_cash_flow, capital_expenditures) do
    operating_cash_flow - capital_expenditures
  end

  ##--------------------------------------------------------------
  ## Goodwill to Assets Calculation
  ## @param float -- goodwill
  ## @param float -- assets
  ## @return float
  ##--------------------------------------------------------------
  def goodwill_to_assets(goodwill, assets) do
    Float.round(goodwill/assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Gross Margin Ratio Calculation
  ## @param float -- gross_margin
  ## @param float -- net_sales
  ## @return float
  ##--------------------------------------------------------------
  def gross_margin_ratio(gross_margin, net_sales) do
    Float.round(gross_margin/net_sales, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Gross Profit Calculation
  ## @param float -- total_sales
  ## @param float -- cogs
  ## @return float
  ##--------------------------------------------------------------
  def gross_profit(total_sales, cogs) do
    total_sales - cogs
  end

  ##--------------------------------------------------------------
  ## Interest Coverage Ratio Calculation
  ## @param float -- ebit
  ## @param float -- interest_expense
  ## @return float
  ##--------------------------------------------------------------
  def interest_coverage_ratio(ebit, interest_expense) do
    Float.round(ebit/interest_expense, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ##
  ##--------------------------------------------------------------
  # TODO: add XIRR wrapper

  ##--------------------------------------------------------------
  ## Inventory Turnover Ratio
  ## @param float -- cogs
  ## @param float -- average_inventory
  ## @return float
  ##--------------------------------------------------------------
  def inventory_turnover_ratio(cogs, average_inventory) do
    Float.round(cogs/average_inventory, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Loan to Value Ratio Calculation
  ## @param float -- mortgage_amount
  ## @param float -- appraised_value_of_property
  ## @return float
  ##--------------------------------------------------------------
  def ltv(mortgage_amount, appraised_value_of_property) do
    Float.round(mortgage_amount/appraised_value_of_property, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Long Term Debt to Total Asset Ratio Calculation
  ## @param float -- long_term_debt
  ## @param float -- total_assets
  ## @return float
  ##--------------------------------------------------------------
  def long_term_debt_to_total_asset_ratio(long_term_debt, total_assets) do
    Float.round(long_term_debt/total_assets, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Margin of Safety Calculation
  ## @param float -- actual_sales
  ## @param float -- break_even_point
  ## @return float
  ##--------------------------------------------------------------
  def margin_of_safety(actual_sales, break_even_point) do
    actual_sales - break_even_point
  end

  ##--------------------------------------------------------------
  ## Margin of Safety Ratio Calculation
  ## @param float -- actual_sales
  ## @param float -- break_even_point
  ## @return float
  ##--------------------------------------------------------------
  def margin_of_safety_ratio(actual_sales, break_even_point) do
    Float.round((actual_sales - break_even_point)/actual_sales, @two_decimal_precision)
  end

  ##--------------------------------------------------------------
  ## Margin of Revenue Calculation
  ## @param float -- change_in_total_revenues
  ## @param float -- change_in_quantity_sold
  ## @return float
  ##--------------------------------------------------------------
  def margin_of_revenue(change_in_total_revenues, change_in_quantity_sold) do
    Float.round(change_in_total_revenues/change_in_quantity_sold, @two_decimal_precision)
  end









end