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
  @zero_error "can't equal zero (Divide by zero error)"


  @doc """
  Net Income Calculation
  """
  def net_income(%Decimal{} = total_revenues, %Decimal{} = total_expenses),
      do: {:ok, D.sub(total_revenues, total_expenses)}

  def net_income(_, _),
      do: {:error, @arg_msg}


  @doc """
  Net Earnings Calculation
  """
  def earnings(%Decimal{} = net_income, %Decimal{} = preferred_dividends),
      do: {:ok, D.sub(net_income, preferred_dividends)}

  def earnings(_, _),
      do: {:error, @arg_msg}


  @doc """
  Retained Earnings Calculation
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
  """
  def ocf(
        %Decimal{} = operating_income,
        %Decimal{} = depreciation,
        %Decimal{} = taxes,
        %Decimal{} = change_in_working_capital
      ) do
    r1 = D.add(operating_income, depreciation)
    r2 = D.add(taxes, change_in_working_capital)

    {:ok, D.sub(r1, r2)}
  end

  def ocf(_, _, _, _),
      do: {:error, @arg_msg}


  @doc """
  Return on Revenue Calculation
  """
  def ror(%Decimal{coef: 0} = _, %Decimal{coef: 0} = _),
      do: {:ok, D.new(0)}

  def ror(_, %Decimal{coef: 0} = _),
      do: {:error, "sales_revenue #{@zero_error}"}

  def ror(%Decimal{} = net_income, %Decimal{} = sales_revenue),
      do: {:ok, D.div(net_income, sales_revenue)}

  def ror(_, _),
      do: {:error, @arg_msg}


  @doc """
  Return on Sales Calculation
  """
  def ros(_, %Decimal{coef: 0} = _),
      do: {:error, "net_sales #{@zero_error}"}

  def ros(%Decimal{} = operating_profit, %Decimal{} = net_sales),
      do: {:ok, D.div(operating_profit, net_sales)}

  def ros(_, _),
      do: {:error, @arg_msg}


  @doc """
  Cost of Goods Sold Calculation
  """
  def cogs(%Decimal{} = beginning_inventory, %Decimal{} = purchases, %Decimal{} = ending_inventory),
      do: {:ok, D.add(beginning_inventory, D.sub(purchases, ending_inventory))}

  def cogs(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  EBIT -- Earnings Before Interest and Taxes Calculation
  """
  def ebit(%Decimal{} = revenue, %Decimal{} = cogs, %Decimal{} = operating_expenses),
      do: {:ok, D.sub(revenue, D.sub(cogs, operating_expenses))}

  def ebit(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  EBITA -- Earnings Before Interest, Taxes, and Amortization Calculation
  """
  def ebita(
        %Decimal{} = revenue,
        %Decimal{} = cogs,
        %Decimal{} = operating_expenses,
        %Decimal{} = amortization
      ) do
    {:ok, D.sub(revenue, D.sub(cogs, D.add(operating_expenses, amortization)))}
  end

  def ebita(_, _, _, _),
      do: {:error, @arg_msg}


  @doc """
  EBITDA -- Earnings Before Interest, Taxes, Depreciation and Amortization Calculation
  """
  def ebitda(
        %Decimal{} = net_income,
        %Decimal{} = interest_expense,
        %Decimal{} = taxes,
        %Decimal{} = depreciation,
        %Decimal{} = amortization
      ) do
      {:ok, D.add(net_income, D.add(interest_expense, D.add(taxes, D.add(depreciation, amortization))))}
  end

  def ebitda(_, _, _, _, _),
      do: {:error, @arg_msg}


  @doc """
  Receivable Turnover Ratio Calculation
  """
  def receivable_turnover_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "avg_accounts_receivable #{@zero_error}"}

  def receivable_turnover_ratio(%Decimal{} = net_credit_sales, %Decimal{} = average_accounts_receivable),
      do: {:ok, D.div(net_credit_sales, average_accounts_receivable)}

  def receivable_turnover_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Accumulated Depreciation to Fixed Assets Calculation
  """
  def accumulated_depreciation_to_fixed_assets(_, %Decimal{coef: 0} = _),
      do: {:error, "total_fixed_assets #{@zero_error}"}

  def accumulated_depreciation_to_fixed_assets(
        %Decimal{} = accumulated_depreciation,
        %Decimal{} = total_fixed_assets
      ) do
    {:ok, D.div(accumulated_depreciation, total_fixed_assets)}
  end

  def accumulated_depreciation_to_fixed_assets(_, _),
      do: {:error, @arg_msg}


  @doc """
  Asset Coverage Ratio Calculation
  """
  def asset_coverage(_, _, _, _, %Decimal{coef: 0} = _),
      do: {:error, "total_debt #{@zero_error}"}

  def asset_coverage(
        %Decimal{} = total_assets,
        %Decimal{} = intangible_assets,
        %Decimal{} = current_liabilities,
        %Decimal{} = short_term_debt,
        %Decimal{} = total_debt
      ) do
      assets = D.sub(total_assets, intangible_assets)
      liabilities = D.sub(current_liabilities, short_term_debt)
      {:ok, D.div(D.sub(assets, liabilities), total_debt)}
  end

  def asset_coverage(_, _, _, _, _),
      do: {:error, @arg_msg}


  @doc """
  Asset Turnover Ratio Calculation
  """
  def asset_turnover(_, %Decimal{coef: 0} = _),
      do: {:error, "average_total_sales #{@zero_error}"}

  def asset_turnover(%Decimal{} = net_sales, %Decimal{} = average_total_sales),
      do: {:ok, D.div(net_sales, average_total_sales)}

  def asset_turnover(_, _),
      do: {:error, @arg_msg}


  @doc """
  Average Inventory Period Calculation
  """
  def average_inventory_period(_, %Decimal{coef: 0} = _),
      do: {:error, "inventory_turnover #{@zero_error}"}

  def average_inventory_period(%Decimal{} = days, %Decimal{} = inventory_turnover),
      do: {:ok, D.div(days, inventory_turnover)}

  def average_inventory_period(_, _), do: {:error, @arg_msg}


  @doc """
  Average Payment Period Calculation
  """
  def average_payment_period(_, %Decimal{coef: 0} = _, 0),
      do: {:error, "days & total_credit_purchases #{@zero_error}"}

  def average_payment_period(_, %Decimal{coef: 0} = _, %Decimal{coef: 0} = _),
      do: {:error, "days & total_credit_purchases #{@zero_error}"}

  def average_payment_period(_, %Decimal{coef: 0} = _, _),
      do: {:error, "total_credit_purchases #{@zero_error}"}

  def average_payment_period(
        %Decimal{} = average_accounts_payable,
        %Decimal{} = total_credit_purchases,
        days
      ) when is_integer(days)
    do
    average_payment_period(average_accounts_payable, total_credit_purchases, D.new(days))
  end

  def average_payment_period(
        %Decimal{} = average_accounts_payable,
        %Decimal{} = total_credit_purchases,
        days
      ) when is_float(days)
    do
    average_payment_period(average_accounts_payable, total_credit_purchases, D.from_float(days))
  end

  def average_payment_period(_, _, %Decimal{coef: 0} = _),
      do: {:error, "days #{@zero_error}"}

  def average_payment_period(
        %Decimal{} = average_accounts_payable,
        %Decimal{} = total_credit_purchases,
        %Decimal{} = days
      ) do
      credit_days = D.div(total_credit_purchases, D.new(days))
      {:ok, D.div(average_accounts_payable, credit_days)}
  end

  def average_payment_period(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Break Even Analysis Calculation
  """
  def break_even_analysis(
        %Decimal{} = fixed_costs,
        %Decimal{} = sales_price_per_unit,
        %Decimal{} = variable_cost_per_unit
      ) do
    price = D.sub(sales_price_per_unit, variable_cost_per_unit)
    cond do
      D.eq?(price, 0) -> {:error, "sales_price_per_unit - variable_cost_per_unit #{@zero_error}"}
      :else -> {:ok, D.div(fixed_costs, price)}
    end
  end

  def break_even_analysis(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Capitalization Ratio Calculation
  """
  def capitalization_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "shareholders_equity #{@zero_error}"}

  def capitalization_ratio(%Decimal{} = total_debt, %Decimal{} = shareholders_equity),
      do: {:ok, D.div(total_debt, D.add(total_debt, shareholders_equity))}

  def capitalization_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Cash Conversion Cycle Calculation
  """
  def cash_conversion_cycle(
        %Decimal{} = days_inventory_outstanding,
        %Decimal{} = days_sales_outstanding,
        %Decimal{} = days_payables_outstanding
      ) do
    {:ok, D.add(days_inventory_outstanding, D.add(days_sales_outstanding, days_payables_outstanding))}
  end

  def cash_conversion_cycle(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Cash Flow Coverage Ratio Calculation
  """
  def cash_flow_coverage(_, %Decimal{coef: 0} = _),
      do: {:error,  "total_debt #{@zero_error}"}

  def cash_flow_coverage(%Decimal{} = operating_cash_flows, %Decimal{} = total_debt) do
      {:ok, D.div(operating_cash_flows, total_debt)}
  end

  def cash_flow_coverage(_, _),
      do: {:error, @arg_msg}


  @doc """
  Cash Ratio Calculation
  """
  def cash_ratio(_, _, %Decimal{coef: 0} = _),
      do: {:error, "cash_equivalents #{@zero_error}"}

  def cash_ratio(
        %Decimal{} = cash,
        %Decimal{} = cash_equivalents,
        %Decimal{} = total_current_liabilities
      ) do
    {:ok, D.div(D.add(cash, cash_equivalents), total_current_liabilities)}
  end

  def cash_ratio(_, _, _),
      do: {:error, @arg_msg}

  @doc """
  Compound Annual Growth Rate Calculation
  """
  def cagr(%Decimal{coef: 0} = _, _, 0),
      do: {:error, "beginning_investment_amount & years #{@zero_error}"}

  def cagr(%Decimal{coef: 0} = _, _, %Decimal{coef: 0} = _),
      do: {:error, "beginning_investment_amount & years #{@zero_error}"}

  def cagr(%Decimal{coef: 0} = _, _, _),
      do: {:error, "beginning_investment_amount #{@zero_error}"}

  def cagr(
        %Decimal{} = beginning_investment_value,
        %Decimal{} = ending_investment_value,
        years
      ) when is_integer(years) do
    cagr(beginning_investment_value, ending_investment_value, D.new(years))
  end

  def cagr(
        %Decimal{} = beginning_investment_value,
        %Decimal{} = ending_investment_value,
        years
      ) when is_float(years) do
    cagr(beginning_investment_value, ending_investment_value, D.from_float(years))
  end

  def cagr(_, _, %Decimal{coef: 0} = _),
      do: {:error, "years #{@zero_error}"}

  def cagr(
        %Decimal{} = beginning_investment_value,
        %Decimal{} = ending_investment_value,
        %Decimal{} = years
      )
    do
      value_ratio = D.div(ending_investment_value, beginning_investment_value)
      time_ratio = D.div(D.new(1), years)
      res = :math.pow(D.to_float(value_ratio), D.to_float(time_ratio))
      {:ok, D.sub(D.new(res), D.new(1))}
  end

  def cagr(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Contribution Margin Calculation
  """
  def contribution_margin(%Decimal{} = net_sales, %Decimal{} = variable_costs),
      do: {:ok, D.sub(net_sales, variable_costs)}

  def contribution_margin(_, _),
      do: {:error, @arg_msg}


  @doc """
  Current Ratio Calculation
  """
  def current_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "current_liabilities #{@zero_error}"}

  def current_ratio(%Decimal{} = current_assets, %Decimal{} = current_liabilities), do:
      {:ok, D.div(current_assets, current_liabilities)}

  def current_ratio(_, _),
      do: {:error, @arg_msg}

  @doc """
  Days Payable Outstanding Calculation
  """
  def dpo(_, %Decimal{coef: 0} = _, %Decimal{coef: 0} = _),
      do: {:error, "cost_of_sales & days #{@zero_error}"}

  def dpo(_, %Decimal{coef: 0} = _, _),
      do: {:error, "cost_of_sales #{@zero_error}"}

  def dpo(%Decimal{} = accounts_payable, %Decimal{} = cost_of_sales, days) when is_integer(days),
      do: dpo(accounts_payable, cost_of_sales, D.new(days))

  def dpo(%Decimal{} = accounts_payable, %Decimal{} = cost_of_sales, days) when is_float(days),
      do: dpo(accounts_payable, cost_of_sales, D.from_float(days))

  def dpo(_, _, %Decimal{coef: 0} = _),
      do: {:error, "days #{@zero_error}"}

  def dpo(%Decimal{} = accounts_payable, %Decimal{} = cost_of_sales, %Decimal{} = days) do
    cost_of_sales_per_day = D.div(cost_of_sales, days)
    {:ok, D.div(accounts_payable, cost_of_sales_per_day)}
  end

  def dpo(_, _, _),
      do: {:error, @arg_msg}

  @doc """
  Days Sales in Inventory Calculation
  """
  def dsi(_, %Decimal{coef: 0} = _),
      do: {:error, "cogs #{@zero_error}"}

  def dsi(%Decimal{} = ending_inventory, %Decimal{} = cogs),
      do: {:ok, D.mult(D.div(ending_inventory,cogs), 365)}

  def dsi(_, _),
      do: {:error, @arg_msg}


  @doc """
  Days Sales Outstanding Calculation
  """
  def dso(_, %Decimal{coef: 0} = _),
      do: {:error, "net_credit_sales #{@zero_error}"}

  def dso(%Decimal{} = accounts_receivable, %Decimal{} = net_credit_sales), do:
      {:ok, D.mult(D.div(accounts_receivable, net_credit_sales), 365)}

  def dso(_, _),
      do: {:error, @arg_msg}


  @doc """
  Debt Ratio Calculation
  """
  def debt_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "total_assets #{@zero_error}"}

  def debt_ratio(%Decimal{} = total_liabilities, %Decimal{} = total_assets),
      do: {:ok, D.div(total_liabilities, total_assets)}

  def debt_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Debt Service Coverage Ratio
  """
  def dscr(_, %Decimal{coef: 0} = _),
      do: {:error, "total_debt_service_costs #{@zero_error}"}

  def dscr(%Decimal{} = operating_income, %Decimal{} = total_debt_service_costs),
      do: {:ok, (Float.round(operating_income/total_debt_service_costs, @two_decimal_precision))}

  def dscr(_, _),
      do: {:error, @arg_msg}


  @doc """
  Debt to Asset Ratio Calculation
  """
  def debt_to_asset(_, %Decimal{coef: 0} = _),
      do: {:error, "total_assets #{@zero_error}"}

  def debt_to_asset(%Decimal{} = total_debt, %Decimal{} = total_assets),
      do: {:ok, D.div(total_debt, total_assets)}

  def debt_to_asset(_, _),
      do: {:error, @arg_msg}

  @doc """
  Debt ot Capital Ratio Calculation
  """
  def debt_to_capital(_, %Decimal{coef: 0} = _),
      do: {:error, "shareholders_equity #{@zero_error}"}

  def debt_to_capital(%Decimal{} = total_debt, %Decimal{} = shareholders_equity),
      do: {:ok, D.div(total_debt, D.add(total_debt, shareholders_equity))}

  def debt_to_capital(_, _),
      do: {:error, @arg_msg}


  @doc """
  Debt to Equity Ratio Calculation
  """
  def debt_to_equity(_, %Decimal{coef: 0} = _),
      do: {:error, "total_equity #{@zero_error}"}

  def debt_to_equity(%Decimal{} = total_liabilities, %Decimal{} = total_equity),
      do: {:ok, D.div(total_liabilities, total_equity)}

  def debt_to_equity(_, _),
      do: {:error, @arg_msg}


  @doc """
  Debt to Income Ratio Calculation
  """
  def dti(_, %Decimal{coef: 0} = _),
      do: {:error, "gross_monthly_income #{@zero_error}"}

  def dti(%Decimal{} = total_monthly_debt_payments, %Decimal{} = gross_monthly_income),
      do: {:ok, D.div(total_monthly_debt_payments, gross_monthly_income)}

  def dti(_, _),
      do: {:error, @arg_msg}


  @doc """
  Defensive Interval Ratio Calculation
  """
  def dir(_, %Decimal{coef: 0} = _),
      do: {:error, "daily_operational_expenses #{@zero_error}"}

  def dir(%Decimal{} = defensive_assets, %Decimal{} = daily_operational_expenses),
      do: {:ok, D.div(defensive_assets, daily_operational_expenses)}

  def dir(_, _),
      do: {:error, @arg_msg}


  @doc """
  Basic Earnings Per Share Calculation
  """
  def eps_basic(_, %Decimal{coef: 0} = _),
      do: {:error, "shares_outstanding #{@zero_error}"}

  def eps_basic(%Decimal{} = earnings, %Decimal{} = shares_outstanding),
      do: {:ok, D.div(earnings, shares_outstanding)}

  def eps_basic(_, _),
      do: {:error, @arg_msg}


  @doc """
  Diluted Earnings Per Share Calculation
  """
  def eps_diluted(%Decimal{} = earnings, %Decimal{} = shares_outstanding, %Decimal{} = diluted_shares) do
    if D.lt?(shares_outstanding, 1) or D.lt?(diluted_shares, 0) do
      {:error, "shares #{@zero_error}"}
    else
      shares = D.add(shares_outstanding, diluted_shares)
      {:ok, D.div(earnings, shares)}
    end
  end

  def eps_diluted(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Pro Forma Earnings Per Share Calculation
  """
  def eps_pro_forma(
        %Decimal{} = acquirers_net_income,
        %Decimal{} = targets_net_income,
        %Decimal{} = incremental_adjustments,
        %Decimal{} = shares_outstanding,
        %Decimal{} = diluted_shares
      ) do
    if D.lt?(shares_outstanding, 1) or D.lt?(diluted_shares, 0) do
      {:error, "shares #{@zero_error}"}
    else
      earnings = D.add(acquirers_net_income, D.add(targets_net_income, incremental_adjustments))
      shares = D.add(shares_outstanding, diluted_shares)
      {:ok, D.div(earnings, shares)}
    end
  end

  def eps_pro_forma(_, _, _, _, _),
      do: {:error, @arg_msg}


  @doc """
  Book Value Earnings Per Share Calculation
  """
  def eps_book_value(_, _, %Decimal{coef: 0} = _),
      do: {:error, "shares_outstanding #{@zero_error}"}

  def eps_book_value(%Decimal{} = total_equity, %Decimal{} = preferred_equity, %Decimal{} = shares_outstanding),
      do: {:ok, D.div(D.sub(total_equity, preferred_equity), shares_outstanding)}

  def eps_book_value(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Retained Earnings Per Share Calculation
  """
  def eps_retained(_, %Decimal{coef: 0} = _),
      do: {:error, "shares_outstanding #{@zero_error}"}

  def eps_retained(%Decimal{} = retained_earnings, %Decimal{} = shares_outstanding),
      do: {:ok, D.div(retained_earnings, shares_outstanding)}

  def eps_retained(_, _),
      do: {:error, @arg_msg}


  @doc """
  Cash Earnings Per Share Calculation
  """
  def eps_cash(_, %Decimal{coef: 0} = _),
      do: {:error, "shares_outstanding #{@zero_error}"}

  def eps_cash(%Decimal{} = operating_cash_flow, %Decimal{} = shares_outstanding),
      do: {:ok, D.div(operating_cash_flow, shares_outstanding)}

  def eps_cash(_, _),
      do: {:error, @arg_msg}


  @doc """
  Price to Earnings Ratio Calculation
  """
  def pe_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "earnings_per_share #{@zero_error}"}

  def pe_ratio(%Decimal{} = price, %Decimal{} = earnings_per_share), do:
      {:ok, D.div(price, earnings_per_share)}

  def pe_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Price to Earnings to Growth Ratio Calculation
  """
  def peg_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "earnings_growth #{@zero_error}"}

  def peg_ratio(%Decimal{} = price_to_earnings, %Decimal{} = earnings_growth),
      do: {:ok, D.div(price_to_earnings, earnings_growth)}

  def peg_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Dividend Payout Calculation
  """
  def dividend_payout(_, %Decimal{coef: 0} = _),
      do: {:error, "net_income #{@zero_error}"}

  def dividend_payout(%Decimal{} = net_dividends, %Decimal{} = net_income),
      do: {:ok, D.div(net_dividends, net_income)}

  def dividend_payout(_, _),
      do: {:error, @arg_msg}


  @doc """
  Dividend Yield Calculation
  """
  def dividend_yield(_, %Decimal{coef: 0} = _),
      do: {:error, "market_value_per_share #{@zero_error}"}

  def dividend_yield(%Decimal{} = cash_dividends_per_share, %Decimal{} = market_value_per_share),
      do: {:ok, D.div(cash_dividends_per_share, market_value_per_share)}

  def dividend_yield(_, _),
      do: {:error, @arg_msg}


  @doc """
  DuPont Analysis Calculation
  """
  def du_pont_analysis(%Decimal{} = profit_margin, %Decimal{} = total_asset_turnover, %Decimal{} = financial_leverage),
      do: {:ok, D.mult(profit_margin, D.mult(total_asset_turnover, financial_leverage))}

  def du_pont_analysis(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Enterprise Value Calculation
  """
  def ev(%Decimal{} = market_capitalization, %Decimal{} = debt, %Decimal{} = current_cash),
      do: {:ok, D.sub(D.add(market_capitalization, debt), current_cash)}

  def ev(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Equity Multiplier Calculation
  """
  def equity_multiplier(_, %Decimal{coef: 0} = _),
      do: {:error, "total_stockholders_equity #{@zero_error}"}

  def equity_multiplier(%Decimal{} = total_assets, %Decimal{} = total_stockholders_equity),
      do: {:ok, D.div(total_assets, total_stockholders_equity)}

  def equity_multiplier(_, _),
      do: {:error, @arg_msg}


  @doc """
  Equity Ratio Calculation
  """
  def equity_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "total_assets #{@zero_error}"}

  def equity_ratio(%Decimal{} = total_equity, %Decimal{} = total_assets),
      do: {:ok, D.div(total_equity, total_assets)}

  def equity_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Expense Ratio Calculation
  """
  def expense_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "average_value_of_fund_assets #{@zero_error}"}

  def expense_ratio(%Decimal{} = operating_expenses, %Decimal{} = average_value_of_fund_assets),
      do: {:ok, D.div(operating_expenses, average_value_of_fund_assets)}

  def expense_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Fixed Asset Turnover Ratio
  """
  def fixed_asset_turnover_ratio(
        %Decimal{} = net_sales,
        %Decimal{} = fixed_assets,
        %Decimal{} = accumulated_depreciation
      ) do
    depreciated_assets = D.sub(fixed_assets, accumulated_depreciation)
    cond do
      D.eq?(depreciated_assets, 0) -> {:error, "fixed_assets - accumulated_depreciation #{@zero_error}"}
      :else -> {:ok, D.div(net_sales, depreciated_assets)}
    end
  end

  def fixed_asset_turnover_ratio(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Fixed Charge Coverage Ratio
  """
  def fixed_charge_coverage_ratio(
        %Decimal{} = ebit,
        %Decimal{} = fixed_charges_before_taxes,
        %Decimal{} = interest
      ) do
    charges = (fixed_charges_before_taxes + interest)
    cond do
      D.eq?(charges, 0) -> {:error, "fixed_charges_before_taxes + interest #{@zero_error}"}
      :else -> {:ok, D.div(D.add(ebit, fixed_charges_before_taxes), charges)}
    end
  end

  def fixed_charge_coverage_ratio(_, _, _),
      do: {:error, @arg_msg}


  @doc """
  Free Cash Flow Calculation
  """
  def fcf(%Decimal{} = operating_cash_flow, %Decimal{} = capital_expenditures),
      do: {:ok, D.sub(operating_cash_flow, capital_expenditures)}

  def fcf(_, _),
      do: {:error, @arg_msg}


  @doc """
  Goodwill to Assets Calculation
  """
  def goodwill_to_assets(_, %Decimal{coef: 0} = _),
      do: {:error, "assets #{@zero_error}"}

  def goodwill_to_assets(%Decimal{} = goodwill, %Decimal{} = assets),
      do: {:ok, D.div(goodwill, assets)}

  def goodwill_to_assets(_, _),
      do: {:error, @arg_msg}


  @doc """
  Gross Margin Ratio Calculation
  """
  def gross_margin_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "net_sales #{@zero_error}"}

  def gross_margin_ratio(%Decimal{} = gross_margin, %Decimal{} = net_sales),
      do: {:ok, D.div(gross_margin, net_sales)}

  def gross_margin_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Gross Profit Calculation
  """
  def gross_profit(%Decimal{} = total_sales, %Decimal{} = cogs),
      do: {:ok, D.sub(total_sales, cogs)}

  def gross_profit(_, _),
      do: {:error, @arg_msg}


  @doc """
  Interest Coverage Ratio Calculation
  """
  def interest_coverage_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "interest_expense #{@zero_error}"}

  def interest_coverage_ratio(%Decimal{} = ebit, %Decimal{} = interest_expense),
      do: {:ok, D.div(ebit, interest_expense)}

  def interest_coverage_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Inventory Turnover Ratio
  """
  def inventory_turnover_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "average_inventory #{@zero_error}"}

  def inventory_turnover_ratio(%Decimal{} = cogs, %Decimal{} = average_inventory), do:
      {:ok, D.div(cogs, average_inventory)}

  def inventory_turnover_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Loan to Value Ratio Calculation
  """
  def ltv(_, %Decimal{coef: 0} = _),
      do: {:error, "appraised_value_of_property #{@zero_error}"}

  def ltv(%Decimal{} = mortgage_amount, %Decimal{} = appraised_value_of_property),
      do: {:ok, D.div(mortgage_amount, appraised_value_of_property)}

  def ltv(_, _),
      do: {:error, @arg_msg}


  @doc """
  Long Term Debt to Total Asset Ratio Calculation
  """
  def long_term_debt_to_total_asset_ratio(_, %Decimal{coef: 0} = _),
      do: {:error, "total_assets #{@zero_error}"}

  def long_term_debt_to_total_asset_ratio(%Decimal{} = long_term_debt, %Decimal{} = total_assets),
      do: {:ok, D.div(long_term_debt, total_assets)}

  def long_term_debt_to_total_asset_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Margin of Safety Calculation
  """
  def margin_of_safety(%Decimal{} = actual_sales, %Decimal{} = break_even_point),
      do: {:ok, D.sub(actual_sales, break_even_point)}

  def margin_of_safety(_, _),
      do: {:error, @arg_msg}


  @doc """
  Margin of Safety Ratio Calculation
  """
  def margin_of_safety_ratio(%Decimal{coef: 0} = _, _),
      do: {:error, "actual_sales #{@zero_error}"}

  def margin_of_safety_ratio(%Decimal{} = actual_sales, %Decimal{} = break_even_point),
      do: {:ok, D.div(D.sub(actual_sales, break_even_point), actual_sales)}

  def margin_of_safety_ratio(_, _),
      do: {:error, @arg_msg}


  @doc """
  Margin of Revenue Calculation
  """
  def margin_of_revenue(_, %Decimal{coef: 0} = _),
      do: {:error, "change_in_quantity_sold #{@zero_error}"}

  def margin_of_revenue(%Decimal{} = change_in_total_revenues, %Decimal{} = change_in_quantity_sold),
      do: {:ok, D.div(change_in_total_revenues, change_in_quantity_sold)}

  def margin_of_revenue(_, _),
      do: {:error, @arg_msg}


end