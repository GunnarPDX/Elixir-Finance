
# Elixir Finance Library 🏦

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)
[![Hex.pm Version](http://img.shields.io/hexpm/v/financials.svg?style=flat)](https://hex.pm/packages/financials)

***This library is currently incomplete!***

A financial modeling library for elixir. Contains functions that can be used as building blocks for complex financial modeling.


## Installation

The package can be installed by adding `financial` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:financials, "~> 0.0.0"}
  ]
end
```

## Usage

Requests return a 2-tuple with the standard `:ok` or `:error` status.

```elixir
# Successful response
{:ok, debt_to_equity_ratio} = Financials.debt_to_equity(100_000, 1_000_000)

# Unsuccessful response due to argument type
{:error, "Arguments must be numerical"} = Financials.net_income(100_000, "1_000_000")

# Unsuccessful response due to argument value
{:error, "total_equity can't be zero (Divide by zero error)"} = Financials.net_income(100_000, 0)
```

## Future plans

- 🎯 Config settings for decimal and rounding accuracy
- 🔢 Config settings for parsing numerical values from string format

## Contributing

Open an issue or create a fork and submit a pull request.

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
#### Cost of Goods Sold
```elixir
cogs(beginning_inventory, purchases, ending_inventory)
```

#### Earnings Before Interest and Taxes
```elixir
ebit(revenue, cogs, operating_expenses)
```

#### Earnings Before Interest, Taxes, and Amortization
```elixir
ebita(revenue, cogs, operating_expenses, amortization)
```

#### Earnings Before Interest, Taxes, Depreciation, and Amortization
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

#### Compounded Annual Growth Rate
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

#### Days Payable Outstanding
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

#### Earnings Per Share - Basic
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

#### Price to Earnings Ratio
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

#### ...
... 
