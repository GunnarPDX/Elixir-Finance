defmodule Financials do

  alias Decimal, as: D

  @moduledoc """
  A financial modeling library for elixir. Contains functions that can be used as building blocks for complex financial modeling.

  ## Usage

  Requests return a 2-tuple with the standard `:ok` or `:error` status.

  ```elixir
  # Successful response
  {:ok, result} = Financials.debt_to_equity(100_000, 1_000_000)

  # Unsuccessful response due to argument type
  {:error, "Arguments must be numerical"} = Financials.net_income(100_000, "1_000_000")

  # Unsuccessful response due to argument value
  {:error, "total_equity can't be zero (Divide by zero error)"} = Financials.net_income(100_000, 0)
  ```

  ## Functions
  """

  ##--------------------------------------------------------------
  ## CONSTANTS
  ##--------------------------------------------------------------
  @two_decimal_precision 2
  @arg_msg "Arguments must be decimals"

  @doc """
  Net Income Calculation
  @param Decimal -- total_revenues
  @param Decimal -- total_expenses
  """
  def net_income(%Decimal{} = total_revenues, %Decimal{} = total_expenses),
      do: {:ok, D.sub(total_revenues, total_expenses)}

  def net_income(_, _),
      do: {:error, @arg_msg}


  @doc """
  Net Earnings Calculation
  @param Decimal -- net_income
  @param Decimal -- preferred_dividends
  """
  def earnings(%Decimal{} = net_income, %Decimal{} = preferred_dividends),
      do: {:ok, D.sub(net_income, preferred_dividends)}

  def earnings(_, _),
      do: {:error, @arg_msg}


  @doc """
  Retained Earnings Calculation
  @param Decimal -- beginning_period_retained_earnings
  @param Decimal -- net_income
  @param Decimal -- cash_dividends
  @param Decimal -- stock_dividends
  """
  def retained_earnings(
        %Decimal{} = beginning_period_retained_earnings,
        %Decimal{} = net_income,
        %Decimal{} = cash_dividends,
        %Decimal{} = stock_dividends
        ) do
    earnings = D.add(beginning_period_retained_earnings, net_income)
    dividend_expenses = D.sub(cash_dividends, stock_dividends)

    {:ok, D.sub(earnings, dividend_expenses)}
  end

  def retained_earnings(_, _, _, _),
      do: {:error, @arg_msg}


  @doc """
  Operating Cash Flow Calculation
  @param Decimal -- operating_income
  @param Decimal -- depreciation
  @param Decimal -- taxes
  @param Decimal -- change_in_working_capital
  """
  def ocf(
        %Decimal{} = operating_income,
        %Decimal{} = depreciation,
        %Decimal{} = taxes,
        %Decimal{} = change_in_working_capital
      )do
    r1 = D.add(operating_income, depreciation)
    r2 = D.add(taxes, change_in_working_capital)

    {:ok, D.sub(r1, r2)}
  end

  def ocf(_, _, _, _),
      do: {:error, @arg_msg}


  @doc """
  Return on Revenue Calculation
  @param Decimal -- net_income
  @param Decimal -- sales_revenue
  """
  def ror(0, 0),
      do: {:ok, D.new(0)}

  def ror(_, 0),
      do: {:error, "sales_revenue cannot be zero (divide by zero error)"}

  def ror(%Decimal{} = net_income, %Decimal{} = sales_revenue),
      do: {:ok, D.div(net_income, sales_revenue)}

  def ror(_, _),
      do: {:error, @arg_msg}


  @doc """
  Return on Sales Calculation
  @param Decimal -- operating_profit
  @param Decimal -- net_sales
  """
  def ros(_, 0),
      do: {:ok, D.new(0)}

  def ros(_, 0),
      do: {:error, "Net sales cannot be zero (divide by zero error"}

  def ros(%Decimal{} = operating_profit, %Decimal{} = net_sales),
      do: {:ok, D.div(operating_profit, net_sales)}

  def ros(_, _),
      do: {:error, @arg_msg}


  @doc """
  Cost of Goods Sold Calculation
  @param Decimal -- beginning_inventory
  @param Decimal -- purchases
  @param Decimal -- ending_inventory
  """
  def cogs(%Decimal{} = beginning_inventory, %Decimal{} = purchases, %Decimal{} = ending_inventory),
      do: {:ok, D.add(beginning_inventory, D.sub(purchases, ending_inventory))}

  def cogs(_, _, _),
      do: {:error, @arg_msg}


  ##--------------------------------------------------------------
  ## EBIT -- Earnings Before Interest and Taxes Calculation
  ## @param Decimal -- revenue
  ## @param Decimal -- cogs
  ## @param Decimal -- operating_expenses
  ## @return Decimal
  ##--------------------------------------------------------------
  def ebit(revenue, cogs, operating_expenses)
    when is_number(revenue)
    and is_number(cogs)
    and is_number(operating_expenses)
    do
      {:ok, (revenue - cogs - operating_expenses)}
  end
  def ebit(_, _, _), do: {:error, "Arguments must be numbers"}

  # TODO: operating_expenses

  ##--------------------------------------------------------------
  ## EBITA -- Earnings Before Interest, Taxes, and Amortization Calculation
  ## @param Decimal -- revenue
  ## @param Decimal -- cogs
  ## @param Decimal -- operating_expenses
  ## @param Decimal -- amortization
  ## @return Decimal
  ##--------------------------------------------------------------
  def ebita(revenue, cogs, operating_expenses, amortization)
    when is_number(revenue)
    and is_number(cogs)
    and is_number(operating_expenses)
    and is_number(amortization)
    do
      {:ok, (revenue - cogs - (operating_expenses + amortization))}
  end
  def ebita(_, _, _, _), do: {:error, "Arguments must be numerical"}

  # TODO: amortization ?

  ##--------------------------------------------------------------
  ## EBITDA -- Earnings Before Interest, Taxes, Depreciation and Amortization Calculation
  ## @param Decimal -- net_income
  ## @param Decimal -- interest_expense
  ## @param Decimal -- taxes
  ## @param Decimal -- depreciation
  ## @param Decimal -- amortization
  ## @return Decimal
  ##--------------------------------------------------------------
  def ebitda(net_income, interest_expense, taxes, depreciation, amortization)
    when is_number(net_income)
    and is_number(interest_expense)
    and is_number(taxes)
    and is_number(depreciation)
    and is_number(amortization)
    do
      {:ok, (net_income + interest_expense + taxes + depreciation + amortization)}
  end
  def ebitda(_, _, _, _, _), do: {:error, "Arguments must be numerical"}

  # TODO: net_credit_sales
  # TODO: average_accounts_receivable

  ##--------------------------------------------------------------
  ## Receivable Turnover Ratio Calculation
  ## @param Decimal -- net_credit_sales
  ## @param Decimal -- average_accounts_receivable
  ## @return Decimal
  ##--------------------------------------------------------------
  def receivable_turnover_ratio(_, 0), do: {:error, "Avg accounts receivable can't be zero (Divide by zero error)"}
  def receivable_turnover_ratio(net_credit_sales, average_accounts_receivable)
    when is_number(net_credit_sales)
    and is_number(average_accounts_receivable)
    do
      {:ok, (Float.round(net_credit_sales/average_accounts_receivable, @two_decimal_precision))}
  end
  def receivable_turnover_ratio(_, _), do: {:error, "Arguments must be numerical"}

  # TODO: accumulated_depreciation
  # TODO: total_fixed_assets

  ##--------------------------------------------------------------
  ## Accumulated Depreciation to Fixed Assets Calculation
  ## @param Decimal -- accumulated_depreciation
  ## @param Decimal -- total_fixed_assets
  ## @return Decimal
  ##--------------------------------------------------------------
  def accumulated_depreciation_to_fixed_assets(_, 0), do: {:error, "Total fixed assets can't be zero (Divide by zero error)"}
  def accumulated_depreciation_to_fixed_assets(accumulated_depreciation, total_fixed_assets)
    when is_number(accumulated_depreciation)
    and is_number(total_fixed_assets)
    do
      {:ok, (Float.round(accumulated_depreciation/total_fixed_assets, @two_decimal_precision))}
  end
  def accumulated_depreciation_to_fixed_assets(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Asset Coverage Ratio Calculation
  ## @param Decimal -- total_assets
  ## @param Decimal -- intangible_assets
  ## @param Decimal -- current_liabilities
  ## @param Decimal -- short_term_debt
  ## @param Decimal -- total_debt
  ## @return Decimal
  ##--------------------------------------------------------------
  def asset_coverage(_, _, _, _, 0), do: {:error, "Total debt can't be zero (Divide by zero error)"}
  def asset_coverage(total_assets, intangible_assets, current_liabilities, short_term_debt, total_debt)
    when is_number(total_assets)
    and is_number(intangible_assets)
    and is_number(current_liabilities)
    and is_number(short_term_debt)
    and is_number(total_debt)
    do
      assets = total_assets - intangible_assets
      liabilities = current_liabilities - short_term_debt
      {:ok, (Float.round((assets - liabilities)/total_debt, @two_decimal_precision))}
  end
  def asset_coverage(_, _, _, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Asset Turnover Ratio Calculation
  ## @param Decimal -- net_sales
  ## @param Decimal -- average_total_sales
  ## @return Decimal
  ##--------------------------------------------------------------
  def asset_turnover(_, 0), do: {:error, "Average total sales can't be zero (Divide by zero error)"}
  def asset_turnover(net_sales, average_total_sales)
    when is_number(net_sales)
    and is_number(average_total_sales)
    do
      {:ok, (Float.round(net_sales/average_total_sales, @two_decimal_precision))}
  end
  def asset_turnover(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Average Inventory Period Calculation
  ## @param int/Decimal -- days
  ## @param Decimal -- inventory_turnover
  ## @return Decimal
  ##--------------------------------------------------------------
  def average_inventory_period(_, 0), do: {:error, "Inventory turnover can't be zero (Divide by zero error)"}
  def average_inventory_period(days, inventory_turnover)
    when is_number(days)
    and is_number(inventory_turnover)
    do
      {:ok, (Float.round(days/inventory_turnover, @two_decimal_precision))}
  end
  def average_inventory_period(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Average Payment Period Calculation
  ## @param Decimal -- average_accounts_payable
  ## @param Decimal -- total_credit_purchases
  ## @param int -- days
  ## @return Decimal
  ##--------------------------------------------------------------
  def average_payment_period(_, 0, 0), do: {:error, "Days and total credit purchases can't be zero (Divide by zero error)"}
  def average_payment_period(_, _, 0), do: {:error, "Days can't be zero (Divide by zero error)"}
  def average_payment_period(_, 0, _), do: {:error, "Total credit purchases can't be zero (Divide by zero error)"}
  def average_payment_period(average_accounts_payable, total_credit_purchases, days)
    when is_number(average_accounts_payable)
    and is_number(total_credit_purchases)
    and is_number(days)
    do
      credit_days = Float.round(total_credit_purchases/days, @two_decimal_precision)
      {:ok, (Float.round(average_accounts_payable/credit_days, @two_decimal_precision))}
  end
  def average_payment_period(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Break Even Analysis Calculation
  ## @param Decimal -- fixed_costs
  ## @param Decimal -- sales_price_per_unit
  ## @param Decimal -- variable_cost_per_unit
  ## @return Decimal
  ##--------------------------------------------------------------
  def break_even_analysis(fixed_costs, sales_price_per_unit, variable_cost_per_unit)
    when is_number(fixed_costs)
    and is_number(sales_price_per_unit)
    and is_number(variable_cost_per_unit)
    do
      case (sales_price_per_unit - variable_cost_per_unit) do
        0 -> {:error, "sales_price_per_unit - variable_cost_per_unit can't equal zero (Divide by zero error)"}
        price -> {:ok, (Float.round(fixed_costs/price, @two_decimal_precision))}
      end
  end
  def break_even_analysis(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Capitalization Ratio Calculation
  ## @param Decimal -- total_debt
  ## @param Decimal -- shareholders_equity
  ## @return Decimal
  ##--------------------------------------------------------------
  def capitalization_ratio(_, 0), do: {:error, "Shareholders_equity can't be zero (Divide by zero error)"}
  def capitalization_ratio(total_debt, shareholders_equity)
    when is_number(total_debt)
    and is_number(shareholders_equity)
    do
      {:ok, (Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision))}
  end
  def capitalization_ratio(_, _), do: {:error, "Arguments must be numerical"}

  # TODO: days_inventory_outstanding
  # TODO: days_sales_outstanding
  # TODO: days_payables_outstanding

  ##--------------------------------------------------------------
  ## Cash Conversion Cycle Calculation
  ## @param Decimal -- days_inventory_outstanding
  ## @param Decimal --  days_sales_outstanding
  ## @param Decimal -- days_payables_outstanding
  ## @return Decimal
  ##--------------------------------------------------------------
  def cash_conversion_cycle(days_inventory_outstanding, days_sales_outstanding, days_payables_outstanding)
    when is_number(days_inventory_outstanding)
    and is_number(days_sales_outstanding)
    and is_number(days_payables_outstanding)
    do
      {:ok, (days_inventory_outstanding + days_sales_outstanding + days_payables_outstanding)}
  end
  def cash_conversion_cycle(_, _, _), do: {:error, "Arguments must be numerical"}


  ##--------------------------------------------------------------
  ## Cash Flow Coverage Ratio Calculation
  ## @param Decimal -- operating_cash_flows
  ## @param Decimal -- total_debt
  ## @return Decimal
  ##--------------------------------------------------------------
  def cash_flow_coverage(_, 0), do: {:error,  "total_debt can't be zero (Divide by zero error)"}
  def cash_flow_coverage(operating_cash_flows, total_debt)
    when is_number(operating_cash_flows)
    and is_number(total_debt)
    do
      {:ok, (Float.round(operating_cash_flows/total_debt, @two_decimal_precision))}
  end
  def cash_flow_coverage(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Cash Ratio Calculation
  ## @param Decimal -- cash
  ## @param Decimal -- cash_equivalents
  ## @param Decimal -- total_current_liabilities
  ## @return Decimal
  ##--------------------------------------------------------------
  def cash_ratio(_, _, 0), do: {:error, "cash_equivalents can't be zero (Divide by zero error)"}
  def cash_ratio(cash, cash_equivalents, total_current_liabilities)
    when is_number(cash)
    and is_number(cash_equivalents)
    and is_number(total_current_liabilities)
    do
      {:ok, (Float.round((cash + cash_equivalents)/total_current_liabilities, @two_decimal_precision))}
  end
  def cash_ratio(_, _, _), do: {:error, "arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Compound Annual Growth Rate Calculation
  ## @param Decimal -- beginning_investment_value
  ## @param Decimal -- ending_investment_value
  ## @param int -- years
  ## @return Decimal
  ##--------------------------------------------------------------
  def cagr(0, _, 0), do: {:error, "beginning_investment_amount and years can't be zero (Divide by zero error)"}
  def cagr(0, _, _), do: {:error, "beginning_investment_amount can't be zero (Divide by zero error)"}
  def cagr(_, _, 0), do: {:error, "years can't be zero (Divide by zero error)"}
  def cagr(beginning_investment_value, ending_investment_value, years)
    when is_number(beginning_investment_value)
    and is_number(ending_investment_value)
    and is_number(years)
    do
      value_ratio = Float.round(ending_investment_value/beginning_investment_value, @two_decimal_precision)
      time_ratio = Float.round(1/years, @two_decimal_precision)
      {:ok, (:math.pow(value_ratio,time_ratio) - 1)}
  end
  def cagr(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Contribution Margin Calculation
  ## @param Decimal -- net_sales
  ## @param Decimal -- variable_costs
  ## @return Decimal
  ##--------------------------------------------------------------
  def contribution_margin(net_sales, variable_costs)
    when is_number(net_sales)
    and is_number(variable_costs)
    do
      {:ok, (net_sales - variable_costs)}
  end
  def contribution_margin(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Current Ratio Calculation
  ## @param Decimal -- current_assets
  ## @param Decimal -- current_liabilities
  ## @return Decimal
  ##--------------------------------------------------------------
  def current_ratio(_, 0), do: {:error, "current_liabilities can't be zero (Divide by zero error)"}
  def current_ratio(current_assets, current_liabilities)
    when is_number(current_assets)
    and is_number(current_liabilities)
    do
      {:ok, (Float.round(current_assets/current_liabilities, @two_decimal_precision))}
  end
  def current_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Days Payable Outstanding Calculation
  ## @param Decimal -- accounts_payable
  ## @param Decimal -- cost_of_sales
  ## @param int -- days
  ## @return Decimal
  ##--------------------------------------------------------------
  def dpo(_, 0, 0), do: {:error, "cost_of_sales and days can't be zero (Divide by zero error)"}
  def dpo(_, 0, _), do: {:error, "cost_of_sales can't be zero (Divide by zero error)"}
  def dpo(_, _, 0), do: {:error, "days can't be zero (Divide by zero error)"}
  def dpo(accounts_payable, cost_of_sales, days)
    when is_number(accounts_payable)
    and is_number(cost_of_sales)
    and is_number(days)
    do
      cost_of_sales_per_day = Float.round(cost_of_sales/days, @two_decimal_precision)
      {:ok, (Float.round(accounts_payable/cost_of_sales_per_day, @two_decimal_precision))}
  end
  def dpo(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Days Sales in Inventory Calculation
  ## @param Decimal -- ending_inventory
  ## @param Decimal -- cogs
  ## @return Decimal
  ##--------------------------------------------------------------
  def dsi(_, 0), do: {:error, "cogs can't be zero (Divide by zero error)"}
  def dsi(ending_inventory, cogs)
    when is_number(ending_inventory)
    and is_number(cogs)
    do
      {:ok, (Float.round(ending_inventory/cogs, @two_decimal_precision) * 365)}
  end
  def dsi(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Days Sales Outstanding Calculation
  ## @param Decimal -- accounts_receivable
  ## @param Decimal -- net_credit_sales
  ## @return Decimal
  ##--------------------------------------------------------------
  def dso(_, 0), do: {:error, "net_credit_sales can't be zero (Divide by zero error)"}
  def dso(accounts_receivable, net_credit_sales)
    when is_number(accounts_receivable)
    and is_number(net_credit_sales)
    do
      {:ok, (Float.round(accounts_receivable/net_credit_sales, @two_decimal_precision) * 365)}
  end
  def dso(_, _), do: {:error, "Arguments must be numerical"}


  ##--------------------------------------------------------------
  ## Debt Ratio Calculation
  ## @param Decimal -- total_liabilities
  ## @param Decimal -- total_assets
  ## @return Decimal
  ##--------------------------------------------------------------
  def debt_ratio(_, 0), do: {:error, "total_assets can't be zero (Divide by zero error)"}
  def debt_ratio(total_liabilities, total_assets)
    when is_number(total_liabilities)
    and is_number(total_assets)
    do
      {:ok, (Float.round(total_liabilities/total_assets, @two_decimal_precision))}
  end
  def debt_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Debt Service Coverage Ratio
  ## @param Decimal -- operating_income
  ## @param Decimal -- total_debt_service_costs
  ## @return Decimal
  ##--------------------------------------------------------------
  def dscr(_, 0), do: {:error, "total_debt_service_costs can't be zero (Divide by zero error)"}
  def dscr(operating_income, total_debt_service_costs)
    when is_number(operating_income)
    and is_number(total_debt_service_costs)
    do
      {:ok, (Float.round(operating_income/total_debt_service_costs, @two_decimal_precision))}
  end
  def dscr(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Debt to Asset Ratio Calculation
  ## @param Decimal -- total_debt
  ## @param float -- total_assets
  ## @return float
  ##--------------------------------------------------------------
  def debt_to_asset(_, 0), do: {:error, "total_assets can't be zero (Divide by zero error)"}
  def debt_to_asset(total_debt, total_assets)
    when is_number(total_debt)
    and is_number(total_assets)
    do
      {:ok, (Float.round(total_debt/total_assets, @two_decimal_precision))}
  end
  def debt_to_asset(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Debt ot Capital Ratio Calculation
  ## @param float -- total_debt
  ## @param float -- shareholders_equity
  ## @return float
  ##--------------------------------------------------------------
  def debt_to_capital(_, 0), do: {:error, "shareholders_equity can't be zero (Divide by zero error)"}
  def debt_to_capital(total_debt, shareholders_equity)
    when is_number(total_debt)
    and is_number(shareholders_equity)
    do
      {:ok, (Float.round(total_debt/(total_debt + shareholders_equity), @two_decimal_precision))}
  end
  def debt_to_capital(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Debt to Equity Ratio Calculation
  ## @param float -- total_liabilities
  ## @param float -- total_equity
  ## @return float
  ##--------------------------------------------------------------
  def debt_to_equity(_, 0), do: {:error, "total_equity can't be zero (Divide by zero error)"}
  def debt_to_equity(total_liabilities, total_equity)
    when is_number(total_liabilities)
    and is_number(total_equity)
    do
      {:ok, (Float.round(total_liabilities/total_equity, @two_decimal_precision))}
  end
  def debt_to_equity(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Debt to Income Ratio Calculation
  ## @param float -- total_monthly_debt_payments
  ## @param float -- gross_monthly_income
  ## @return float
  ##--------------------------------------------------------------
  def dti(_, 0), do: {:error, "gross_monthly_income can't be zero (Divide by zero error)"}
  def dti(total_monthly_debt_payments, gross_monthly_income)
    when is_number(total_monthly_debt_payments)
    and is_number(gross_monthly_income)
    do
      {:ok, (Float.round(total_monthly_debt_payments/gross_monthly_income, @two_decimal_precision))}
  end
  def dti(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Defensive Interval Ratio Calculation
  ## @param float -- defensive_assets
  ## @param float -- daily_operational_expenses
  ## @return float
  ##--------------------------------------------------------------
  def dir(_, 0), do: {:error, "daily_operational_expenses can't be zero (Divide by zero error)"}
  def dir(defensive_assets, daily_operational_expenses)
    when is_number(defensive_assets)
    and is_number(daily_operational_expenses)
    do
      {:ok, (Float.round(defensive_assets/daily_operational_expenses, @two_decimal_precision))}
  end
  def dir(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Basic Earnings Per Share Calculation
  ## @param float -- earnings
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_basic(_, 0), do: {:error, "shares_outstanding can't be zero (Divide ny zero error)"}
  def eps_basic(earnings, shares_outstanding)
    when is_number(earnings)
    and is_number(shares_outstanding)
    do
      {:ok, (Float.round(earnings/shares_outstanding, @two_decimal_precision))}
  end

  def eps_basic(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Diluted Earnings Per Share Calculation
  ## @param float -- earnings
  ## @param float -- shares_outstanding
  ## @param float -- diluted_shares
  ## @return float
  ##--------------------------------------------------------------
  def eps_diluted(_, shares_outstanding, diluted_shares)
    when shares_outstanding <= 0
    or diluted_shares < 0,
    do: {:error, "shares can't be zero (Divide by zero error)"}
  def eps_diluted(earnings, shares_outstanding, diluted_shares)
    when is_number(earnings)
    and is_number(shares_outstanding)
    and is_number(diluted_shares)
    do
      shares = (shares_outstanding + diluted_shares)
      {:ok, (Float.round(earnings/shares, @two_decimal_precision))}
  end
  def eps_diluted(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Pro Forma Earnings Per Share Calculation
  ## @param float -- acquirers_net_income
  ## @param float -- targets_net_income
  ## @param float -- incremental_adjustments
  ## @param float -- shares_outstanding
  ## @param float -- diluted_shares
  ## @return float
  ##--------------------------------------------------------------
  def eps_pro_forma(_, _, _, shares_outstanding, diluted_shares)
    when shares_outstanding <= 0
    or diluted_shares < 0,
    do: {:error, "shares can't be zero (Divide by zero error)"}
  def eps_pro_forma(acquirers_net_income, targets_net_income, incremental_adjustments, shares_outstanding, diluted_shares)
    when is_number(acquirers_net_income)
    and is_number(targets_net_income)
    and is_number(incremental_adjustments)
    and is_number(shares_outstanding)
    and is_number(diluted_shares)
    do
      earnings = (acquirers_net_income + targets_net_income + incremental_adjustments)
      shares = (shares_outstanding + diluted_shares)
      {:ok, (Float.round(earnings/shares, @two_decimal_precision))}
  end
  def eps_pro_forma(_, _, _, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Book Value Earnings Per Share Calculation
  ## @param float -- total_equity
  ## @param float -- preferred_equity
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_book_value(_, _, 0), do: {:error, "shares_outstanding can't be zero (Divide by zero error)"}
  def eps_book_value(total_equity, preferred_equity, shares_outstanding)
    when is_number(total_equity)
    and is_number(preferred_equity)
    and is_number(shares_outstanding)
    do
      {:ok, (Float.round((total_equity - preferred_equity)/shares_outstanding, @two_decimal_precision))}
  end
  def eps_book_value(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Retained Earnings Per Share Calculation
  ## @param float -- retained_earnings
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_retained(_, 0), do: {:error, "shares_outstanding can't be zero (Divide by zero error)"}
  def eps_retained(retained_earnings, shares_outstanding)
    when is_number(retained_earnings)
    and is_number(shares_outstanding)
    do
      {:ok, (Float.round(retained_earnings/shares_outstanding, @two_decimal_precision))}
  end
  def eps_retained(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Cash Earnings Per Share Calculation
  ## @param float -- operating_cash_flow
  ## @param float -- shares_outstanding
  ## @return float
  ##--------------------------------------------------------------
  def eps_cash(_, 0), do: {:error, "shares_outstanding can't be zero (Divide by zero error)"}
  def eps_cash(operating_cash_flow, shares_outstanding)
    when is_number(operating_cash_flow)
    and is_number(shares_outstanding)
    do
      {:ok, (Float.round(operating_cash_flow/shares_outstanding, @two_decimal_precision))}
  end
  def eps_cash(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Price to Earnings Ratio Calculation
  ## @param float -- price
  ## @param float -- earnings_per_share
  ## @return float
  ##--------------------------------------------------------------
  def pe_ratio(_, 0), do: {:error, "earnings_per_share can't be zero (Divide by zero error)"}
  def pe_ratio(price, earnings_per_share)
    when is_number(price)
    and is_number(earnings_per_share)
    do
      {:ok, (Float.round(price/earnings_per_share, @two_decimal_precision))}
  end
  def pe_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Price to Earnings to Growth Ratio Calculation
  ## @param float -- price_to_earnings
  ## @param float -- earnings_growth
  ## @return float
  ##--------------------------------------------------------------
  def peg_ratio(_, 0), do: {:error, "earnings_growth can't be zero (Divide by zero error)"}
  def peg_ratio(price_to_earnings, earnings_growth)
    when is_number(price_to_earnings)
    and is_number(earnings_growth)
    do
      {:ok, (Float.round(price_to_earnings/earnings_growth, @two_decimal_precision))}
  end
  def peg_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Dividend Payout Calculation
  ## @param float -- net_dividends
  ## @param float -- net_income
  ## @return float
  ##--------------------------------------------------------------
  def dividend_payout(_, 0), do: {:error, "net_income can't be zero (Divide by zero error)"}
  def dividend_payout(net_dividends, net_income)
    when is_number(net_dividends)
    and is_number(net_income)
    do
      {:ok, (Float.round(net_dividends/net_income, @two_decimal_precision))}
  end
  def dividend_payout(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Dividend Yield Calculation
  ## @param float -- cash_dividends_per_share
  ## @param float -- market_value_per_share
  ## @return float
  ##--------------------------------------------------------------
  def dividend_yield(_, 0), do: {:error, "market_value_per_share can't be zero (Divide by zero error)"}
  def dividend_yield(cash_dividends_per_share, market_value_per_share)
    when is_number(cash_dividends_per_share)
    and is_number(market_value_per_share)
    do
      {:ok, (Float.round(cash_dividends_per_share/market_value_per_share, @two_decimal_precision))}
  end
  def dividend_yield(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## DuPont Analysis Calculation
  ## @param float -- profit_margin
  ## @param float -- total_asset_turnover
  ## @param float -- financial_leverage
  ## @return float
  ##--------------------------------------------------------------
  def du_pont_analysis(profit_margin, total_asset_turnover, financial_leverage)
    when is_number(profit_margin)
    and is_number(total_asset_turnover)
    and is_number(financial_leverage)
    do
      {:ok, (profit_margin * total_asset_turnover * financial_leverage)}
  end
  def du_pont_analysis(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Enterprise Value Calculation
  ## @param float -- market_capitalization
  ## @param float -- debt
  ## @param float -- current_cash
  ## @return float
  ##--------------------------------------------------------------
  def ev(market_capitalization, debt, current_cash)
    when is_number(market_capitalization)
    and is_number(debt)
    and is_number(current_cash)
    do
      {:ok, (market_capitalization + debt - current_cash)}
  end
  def ev(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Equity Multiplier Calculation
  ## @param float -- total_assets
  ## @param float -- total_stockholders_equity
  ## @return float
  ##--------------------------------------------------------------
  def equity_multiplier(_, 0), do: {:error, "total_stockholders_equity can't be zero (Divide by zero error)"}
  def equity_multiplier(total_assets, total_stockholders_equity)
    when is_number(total_assets)
    and is_number(total_stockholders_equity)
    do
      {:ok, (Float.round(total_assets/total_stockholders_equity, @two_decimal_precision))}
  end
  def equity_multiplier(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Equity Ratio Calculation
  ## @param float -- total_equity
  ## @param float -- total_assets
  ## @return float
  ##--------------------------------------------------------------
  def equity_ratio(_, 0), do: {:error, "total_assets can't be zero (Divide by zero error)"}
  def equity_ratio(total_equity, total_assets)
    when is_number(total_assets)
    and is_number(total_equity)
    do
      {:ok, (Float.round(total_equity/total_assets, @two_decimal_precision))}
  end
  def equity_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Expense Ratio Calculation
  ## @param float -- operating_expenses
  ## @param float -- average_value_of_fund_assets
  ## @return float
  ##--------------------------------------------------------------
  def expense_ratio(_, 0), do: {:error, "average_value_of_fund_assets can't be zero (Divide by zero error)"}
  def expense_ratio(operating_expenses, average_value_of_fund_assets)
    when is_number(operating_expenses)
    and is_number(average_value_of_fund_assets)
    do
      {:ok, (Float.round(operating_expenses/average_value_of_fund_assets, @two_decimal_precision))}
  end
  def expense_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Fixed Asset Turnover Ratio
  ## @param float -- net_sales
  ## @param float -- fixed_assets
  ## @param float -- accumulated_depreciation
  ## @return float
  ##--------------------------------------------------------------
  def fixed_asset_turnover_ratio(net_sales, fixed_assets, accumulated_depreciation)
    when is_number(net_sales)
    and is_number(fixed_assets)
    and is_number(accumulated_depreciation)
    do
      case (fixed_assets - accumulated_depreciation) do
        0 -> {:error, "fixed_assets - accumulated_depreciation can't equal zero (Divide by zero error)"}
        depreciated_assets -> {:ok, (Float.round(net_sales/depreciated_assets, @two_decimal_precision))}
      end
  end
  def fixed_asset_turnover_ratio(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Fixed Charge Coverage Ratio
  ## @param float -- ebit
  ## @param float -- fixed_charges_before_taxes
  ## @param float -- interest
  ## @return float
  ##--------------------------------------------------------------
  def fixed_charge_coverage_ratio(ebit, fixed_charges_before_taxes, interest)
    when is_number(ebit)
    and is_number(fixed_charges_before_taxes)
    and is_number(interest)
    do
      case (fixed_charges_before_taxes + interest) do
        0 -> {:error, "fixed_charges_before_taxes + interest can't equal zero (Divide by zero error)"}
        res -> {:ok, (Float.round((ebit + fixed_charges_before_taxes)/res, @two_decimal_precision))}
      end
  end
  def fixed_charge_coverage_ratio(_, _, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Free Cash Flow Calculation
  ## @param float -- operating_cash_flow
  ## @param float -- capital_expenditures
  ## @return float
  ##--------------------------------------------------------------
  def fcf(operating_cash_flow, capital_expenditures)
    when is_number(operating_cash_flow)
    and is_number(capital_expenditures)
    do
      {:ok, (operating_cash_flow - capital_expenditures)}
  end
  def fcf(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Goodwill to Assets Calculation
  ## @param float -- goodwill
  ## @param float -- assets
  ## @return float
  ##--------------------------------------------------------------
  def goodwill_to_assets(_, 0), do: {:error, "assets can't be zero (Divide by zero error)"}
  def goodwill_to_assets(goodwill, assets)
    when is_number(goodwill)
    and is_number(assets)
    do
      {:ok, Float.round(goodwill/assets, @two_decimal_precision)}
  end
  def goodwill_to_assets(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Gross Margin Ratio Calculation
  ## @param float -- gross_margin
  ## @param float -- net_sales
  ## @return float
  ##--------------------------------------------------------------
  def gross_margin_ratio(_, 0), do: {:error, "net_sales can't be zero (Divide by zero error)"}
  def gross_margin_ratio(gross_margin, net_sales)
    when is_number(gross_margin)
    and is_number(net_sales)
    do
      {:ok, (Float.round(gross_margin/net_sales, @two_decimal_precision))}
  end
  def gross_margin_ratio(_, _), do: {:error, "Arguments must be numerical"}


  ##--------------------------------------------------------------
  ## Gross Profit Calculation
  ## @param float -- total_sales
  ## @param float -- cogs
  ## @return float
  ##--------------------------------------------------------------
  def gross_profit(total_sales, cogs)
    when is_number(total_sales)
    and is_number(cogs)
    do
      {:ok, (total_sales - cogs)}
  end
  def gross_profit(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Interest Coverage Ratio Calculation
  ## @param float -- ebit
  ## @param float -- interest_expense
  ## @return float
  ##--------------------------------------------------------------
  def interest_coverage_ratio(_, 0), do: {:error, "interest_expense can't be zero (Divide by zero error)"}
  def interest_coverage_ratio(ebit, interest_expense)
    when is_number(ebit)
    and is_number(interest_expense)
    do
      {:ok, (Float.round(ebit/interest_expense, @two_decimal_precision))}
  end
  def interest_coverage_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Inventory Turnover Ratio
  ## @param float -- cogs
  ## @param float -- average_inventory
  ## @return float
  ##--------------------------------------------------------------
  def inventory_turnover_ratio(_, 0), do: {:error, "average_inventory can't be zero (Divide by zero error)"}
  def inventory_turnover_ratio(cogs, average_inventory)
    when is_number(cogs)
    and is_number(average_inventory)
    do
      {:ok, (Float.round(cogs/average_inventory, @two_decimal_precision))}
  end
  def inventory_turnover_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Loan to Value Ratio Calculation
  ## @param float -- mortgage_amount
  ## @param float -- appraised_value_of_property
  ## @return float
  ##--------------------------------------------------------------
  def ltv(_, 0), do: {:error, "appraised_value_of_property can't be zero (Divide by zero error)"}
  def ltv(mortgage_amount, appraised_value_of_property)
    when is_number(mortgage_amount)
    and is_number(appraised_value_of_property)
    do
      {:ok, (Float.round(mortgage_amount/appraised_value_of_property, @two_decimal_precision))}
  end
  def ltv(_, _), do: {:error, "Arguments must be numerical"}


  ##--------------------------------------------------------------
  ## Long Term Debt to Total Asset Ratio Calculation
  ## @param float -- long_term_debt
  ## @param float -- total_assets
  ## @return float
  ##--------------------------------------------------------------
  def long_term_debt_to_total_asset_ratio(_, 0), do: {:error, "total_assets can't be zero (Divide by zero error)"}
  def long_term_debt_to_total_asset_ratio(long_term_debt, total_assets)
    when is_number(long_term_debt)
    and is_number(total_assets)
    do
      {:ok, (Float.round(long_term_debt/total_assets, @two_decimal_precision))}
  end
  def long_term_debt_to_total_asset_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Margin of Safety Calculation
  ## @param float -- actual_sales
  ## @param float -- break_even_point
  ## @return float
  ##--------------------------------------------------------------
  def margin_of_safety(actual_sales, break_even_point)
    when is_number(actual_sales)
    and is_number(break_even_point)
    do
      {:ok, (actual_sales - break_even_point)}
  end
  def margin_of_safety(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Margin of Safety Ratio Calculation
  ## @param float -- actual_sales
  ## @param float -- break_even_point
  ## @return float
  ##--------------------------------------------------------------
  def margin_of_safety_ratio(0, _), do: {:error, "actual_sales can't be zero (Divide by zero error)"}
  def margin_of_safety_ratio(actual_sales, break_even_point)
    when is_number(actual_sales)
    and is_number(break_even_point)
    do
      {:ok, (Float.round((actual_sales - break_even_point)/actual_sales, @two_decimal_precision))}
  end
  def margin_of_safety_ratio(_, _), do: {:error, "Arguments must be numerical"}

  ##--------------------------------------------------------------
  ## Margin of Revenue Calculation
  ## @param float -- change_in_total_revenues
  ## @param float -- change_in_quantity_sold
  ## @return float
  ##--------------------------------------------------------------
  def margin_of_revenue(_, 0), do: {:error, "change_in_quantity_sold can't be zero (Divide by zero error)"}
  def margin_of_revenue(change_in_total_revenues, change_in_quantity_sold)
    when is_number(change_in_total_revenues)
    and is_number(change_in_quantity_sold)
    do
      {:ok, (Float.round(change_in_total_revenues/change_in_quantity_sold, @two_decimal_precision))}
  end
  def margin_of_revenue(_, _), do: {:error, "Arguments must be numerical"}


end