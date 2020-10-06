
# Elixir Finance Library 🏦

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)
[![Hex.pm Version](http://img.shields.io/hexpm/v/financials.svg?style=flat)](https://hex.pm/packages/financials)

A financial modeling library for elixir. Contains functions that can be used as building blocks for complex financial modeling.

## Hex

- Package: [Link](https://hex.pm/packages/financials)
- Hex Docs: [Link](https://hexdocs.pm/financials/api-reference.html)

## Installation

The package can be installed by adding `financial` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:financials, "~> 0.1.0"}
  ]
end
```

## Usage

### Params 

All arguments must be decimals with the exception of "strictly integer type" arguments such as `days` which may be either decimal, float or int. If you are unsure just use decimals.


### Return Values

Requests return a 2-tuple with the standard `:ok` or `:error` status.

All results within `:ok` tuples are Decimals, and are string error-messages in `:error` tuples.


#### Ex:
```elixir
# Successful response
{:ok, result} = Financials.debt_to_equity(Decimal<100.23>, Decimal<25.32>)

# Unsuccessful response due to argument type
{:error, "Arguments must be decimals"} = Financials.net_income(123.23, "23.45")

# Unsuccessful response due to argument value
{:error, "total_equity can't be zero (Divide by zero error)"} = Financials.net_income(Decimal<100000.00>, Decimal<0>)
```


## Decimal Context
- For more info check the `Decimal` hex docs [here](https://hexdocs.pm/decimal/readme.html#using-the-context).

#### Using the context

The context specifies the maximum precision of the result of calculations and
the rounding algorithm if the result has a higher precision than the specified
maximum. It also holds the list of set of trap enablers and the currently set
flags.

The context is stored in the process dictionary, this means that you don't have
to pass the context around explicitly and the flags will be updated
automatically.

The context is accessed with `Decimal.Context.get/0` and set with
`Decimal.Context.set/1`. It can also be temporarily set with
`Decimal.Context.with/2`.

```elixir
iex> D.Context.get()
# %Decimal.Context{flags: [:rounded, :inexact], precision: 9, rounding: :half_up,
#  traps: [:invalid_operation, :division_by_zero]}

iex> D.Context.set(%D.Context{D.Context.get() | traps: []})
# :ok

iex> D.Context.get()
# %Decimal.Context{flags: [:rounded, :inexact], precision: 9, rounding: :half_up,
#  traps: []}
```

#### Precision and rounding

The precision is used to limit the amount of decimal digits in the coefficient:

```elixir
iex> D.Context.set(%D.Context{D.Context.get() | precision: 9})
# :ok

iex> D.div(100, 3)
# Decimal<33.3333333>

iex> D.Context.set(%D.Context{D.Context.get() | precision: 2})
# :ok

iex> D.div(100, 3)
# Decimal<33>
```

The rounding algorithm specifies how the result of an operation shall be rounded
when it get be represented with the current precision:

```elixir
iex> D.Context.set(%D.Context{D.Context.get() | rounding: :half_up})
# :ok

iex> D.div(31, 2)
# Decimal<16>

iex> D.Context.set(%D.Context{D.Context.get() | rounding: :floor})
# :ok

iex> D.div(31, 2)
# Decimal<15>
```

## Functions

#### Net Income

```elixir
net_income(total_revenues, total_expenses)
```

#### Earnings
```elixir
earnings(net_income, preferred_dividends)
```

#### Retained Earnings
```elixir
retained_earnings(beginning_period_retained_earnings, net_income, cash_dividends, stock_dividends)
```

#### Operating Cash Flow
```elixir
ocf(operating_income, depreciation, taxes, change_in_working_capital)
```

#### Return on Revenue
```elixir
ror(net_income, sales_revenue)
```

#### Return on Sales
```elixir
ros(operating_profit, net_sales)
```
#### COGS -- Cost of Goods Sold
```elixir
cogs(beginning_inventory, purchases, ending_inventory)
```

#### EBIT -- Earnings Before Interest and Taxes
```elixir
ebit(revenue, cogs, operating_expenses)
```

#### EBITA -- Earnings Before Interest, Taxes, and Amortization
```elixir
ebita(revenue, cogs, operating_expenses, amortization)
```

#### EBITDA -- Earnings Before Interest, Taxes, Depreciation, and Amortization
```elixir
ebitda(net_income, interest_expense, taxes, depreciation, amortization)
```

#### Receivable Turnover Ratio
```elixir
receivable_turnover_ratio(net_credit_sales, average_accounts_receivable)
```

#### Accumulated Depreciation to Fixed Assets
```elixir
accumulated_depreciation_to_fixed_assets(accumulated_depreciation, total_fixed_assets)
```

#### Asset Coverage
```elixir
asset_coverage(total_assets, intangible_assets, current_liabilities, short_term_debt, total_debt)
```

#### Asset Turnover
```elixir
asset_turnover(net_sales, average_total_sales)
```

#### Average Inventory Period
```elixir
average_inventory_period(days, inventory_turnover)
```

#### Average Payment Period
```elixir
average_payment_period(average_accounts_payable, total_credit_purchases, days)
```

#### Break Even Analysis
```elixir
break_even_analysis(fixed_costs, sales_price_per_unit, variable_cost_per_unit)
```

#### Capitalization Ratio
```elixir
capitalization_ratio(total_debt, shareholders_equity)
```

#### Cash Conversion Cycle
```elixir
cash_conversion_cycle(days_inventory_outstanding, days_sales_outstanding, days_payables_outstanding)
```

#### Cash Flow Coverage
```elixir
cash_flow_coverage(operating_cash_flows, total_debt)
```

#### Cash Ratio
```elixir
cash_ratio(cash, cash_equivalents, total_current_liabilities)
```

#### CAGR -- Compounded Annual Growth Rate
```elixir
cagr(beginning_investment_value, ending_investment_value, years)
```

#### Contribution Margin
```elixir
contribution_margin(net_sales, variable_costs)
```

#### Current Ratio
```elixir
current_ratio(current_assets, current_liabilities)
```

#### DPO -- Days Payable Outstanding
```elixir
dpo(accounts_payable, cost_of_sales, days)
```

#### Days Sales in Inventory
```elixir
days_sales_in_inventory(ending_inventory, cogs)
```

#### Days Sales Outstanding
```elixir
days_sales_outstanding(accounts_receivable, net_credit_sales)
```

#### Debt Ratio
```elixir
debt_ratio(total_liabilities, total_assets)
```

#### Debt Service Coverage Ratio
```elixir
dscr(operating_income, total_debt_service_costs)
```

#### Debt to Asset Ratio
```elixir
debt_to_asset(total_debt, total_assets)
```

#### Debt to Capital Ratio
```elixir
debt_to_capital(total_debt, shareholders_equity)
```

#### Debt to Equity Ratio
```elixir
debt_to_equity(total_liabilities, total_equity)
```

#### Debt to Income Ratio
```elixir
dti(total_monthly_debt_payments, gross_monthly_income)
```

#### Defensive Interval Ratio
```elixir
dir(defensive_assets, daily_operational_expenses)
```

#### EPS -- Earnings Per Share - Basic
```elixir
eps_basic(earnings, shares_outstanding)
```

#### Diluted Earnings Per Share
```elixir
eps_diluted(earnings, shares_outstanding, diluted_shares)
```

#### Pro-Forma Earnings Per Share
```elixir
eps_pro_forma(acquirers_net_income, targets_net_income, incremental_adjustments, shares_outstanding, diluted_shares)
```

#### Book Value Earning Per Share
```elixir
eps_book_value(total_equity, preferred_equity, shares_outstanding)
```

#### Retained Earnings Per Share
```elixir
eps_retained(retained_earnings, shares_outstanding)
```

#### Cash Earnings Per Share
```elixir
eps_cash(operating_cash_flow, shares_outstanding)
```

#### PE -- Price to Earnings Ratio
```elixir
pe_ratio(price, earnings_per_share)
```

#### Price to Earnings to Growth Ratio
```elixir
peg_ratio(price_to_earnings, earnings_growth)
```

#### Dividend Payout Ratio
```elixir
dividend_payout(net_dividends, net_income)
```

#### Dividend Yield
```elixir
dividend_yield(cash_dividends_per_share, market_value_per_share)
```

#### DuPont Analysis
```elixir
du_pont_analysis(profit_margin, total_asset_turnover, financial_leverage)
```

#### Enterprise Value
```elixir
ev(market_capitalization, debt, current_cash)
```

#### Equity Multiplier
```elixir
equity_multiplier(total_assets, total_stockholders_equity)
```

#### Equity Ratio
```elixir
equity_ratio(total_equity, total_assets)
```

#### Expense Ratio
```elixir
expense_ratio(operating_expenses, average_value_of_fund_assets)
```

#### Fixed Asset Turnover Ratio
```elixir
fixed_asset_turnover_ratio(net_sales, fixed_assets, accumulated_depreciation)
```

#### Fixed Charge Coverage Ratio
```elixir
fixed_charge_coverage_ratio(ebit, fixed_charges_before_taxes, interest)
```

#### Free Cash Flow
```elixir
fcf(operating_cash_flow, capital_expenditures)
```

#### Goodwill to Assets
```elixir
goodwill_to_assets(goodwill, assets)
```

#### Gross Margin Ratio
```elixir
gross_margin_ratio(gross_margin, net_sales)
```

#### Gross Profit
```elixir
gross_profit(total_sales, cogs)
```

#### Interest Coverage Ratio 
```elixir
interest_coverage_ratio(ebit, interest_expense)
```

#### Inventory Turnover Ratio
```elixir
inventory_turnover_ratio(cogs, average_inventory)
```

#### Loan to Value Ratio
```elixir
ltv(mortgage_amount, appraised_value_of_property)
```

#### Long Term Debt to Total Asset Ratio 
```elixir
long_term_debt_to_total_asset_ratio(long_term_debt, total_assets)
```

#### Margin of Safety
```elixir
margin_of_safety(actual_sales, break_even_point)
```

#### Margin of Safety Ratio
```elixir
margin_of_safety_ratio(actual_sales, break_even_point)
```

#### Margin of Revenue
```elixir
margin_of_revenue(change_in_total_revenues, change_in_quantity_sold)
```




## Contributing

Open an issue or create a fork and submit a pull request.


