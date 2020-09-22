
# Elixir Finance Library 🏦

***This library is currently incomplete!***

This is a finance library for elixir containing functions for common financial calculations that can be used as building blocks for complex financial modeling.


## Installation

The package can (soon) be installed by adding `financial` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:financials, "~> 0.1"}
  ]
end
```

## Usage

Requests return a 2-tuple with the standard `:ok` or `:error` status.

```elixir
# Successful response
{:ok, de_ratio} = Financials.debt_to_equity(100_000, 1_000_000)

# Unsuccessful response due to argument type
{:error, "Arguments must be numerical"} = Financials.net_income(100_000, "1_000_000")

# Unsuccessful response due to argument value
{:error, "total_equity can't be zero (Divide by zero error)"} = Financials.net_income(100_000, 0)
```

## Future plans

- Config settings for decimal and rounding accuracy
- Config settings for parsing numerical values from string format

## Contributing

Open an issue or create a fork and submit a pull request.

## Functions

#### Net Income
* `net_income(total_revenues, total_expenses)`

#### Earnings
* `earnings(net_income, preferred_dividends)`

#### Retained Earnings
* `retained_earnings(beginning_period_retained_earnings, net_income, cash_dividends, stock_dividends)`

#### Operating Cash Flow
* `ocf(operating_income, depreciation, taxes, change_in_working_capital)`

#### Return on Revenue
* `ror(net_income, sales_revenue)`

#### Return on Sales
* `ros(operating_profit, net_sales)`

#### Cost of Goods Sold
* `cogs(beginning_inventory, purchases, ending_inventory)`

#### Earnings Before Interest and Taxes
* `ebit(revenue, cogs, operating_expenses)`

#### Earnings Before Interest, Taxes, and Amortization
* `ebita(revenue, cogs, operating_expenses, amortization)`

#### Earnings Before Interest, Taxes, Depreciation, and Amortization
* `ebitda(net_income, interest_expense, taxes, depreciation, amortization)`

#### Receivable Turnover Ratio
* `receivable_turnover_ratio(net_credit_sales, average_accounts_receivable)`

#### Accumulated Depreciation to Fixed Assets
* `accumulated_depreciation_to_fixed_assets(accumulated_depreciation, total_fixed_assets)`

#### Asset Coverage
* `asset_coverage(total_assets, intangible_assets, current_liabilities, short_term_debt, total_debt)`

#### Asset Turnover
* `asset_turnover(net_sales, average_total_sales)`

#### Average Inventory Period
* `average_inventory_period(days, inventory_turnover)`

#### Average Payment Period
* `average_payment_period(average_accounts_payable, total_credit_purchases, days)`

#### Break Even Analysis
* `break_even_analysis(fixed_costs, sales_price_per_unit, variable_cost_per_unit)`

#### Capitalization Ratio
* `capitalization_ratio(total_debt, shareholders_equity)`

#### Cash Conversion Cycle
* `cash_conversion_cycle(days_inventory_outstanding, days_sales_outstanding, days_payables_outstanding)`

#### Cash Flow Coverage
* `cash_flow_coverage(operating_cash_flows, total_debt)`

#### Cash Ratio
* `cash_ratio(cash, cash_equivalents, total_current_liabilities)`

#### Compounded Annual Growth Rate
* `cagr(beginning_investment_value, ending_investment_value, years)`

#### Contribution Margin
* `contribution_margin(net_sales, variable_costs)`

#### Current Ratio
* `current_ratio(current_assets, current_liabilities)`

#### Days Payable Outstanding
* `dpo(accounts_payable, cost_of_sales, days)`

#### Days Sales in Inventory
* `days_sales_in_inventory(ending_inventory, cogs)`

#### Days Sales Outstanding
* `days_sales_outstanding(accounts_receivable, net_credit_sales)`

#### Debt Ratio
* `debt_ratio(total_liabilities, total_assets)`

#### Debt Service Coverage Ratio
* `dscr(operating_income, total_debt_service_costs)`

#### Debt to Asset Ratio
* `debt_to_asset(total_debt, total_assets)`

#### Debt to Capital Ratio
* `debt_to_capital(total_debt, shareholders_equity)`

#### Debt to Equity Ratio
* `debt_to_equity(total_liabilities, total_equity)`

#### Debt to Income Ratio
* `dti(total_monthly_debt_payments, gross_monthly_income)`

#### Defensive Interval Ratio
* `dir(defensive_assets, daily_operational_expenses)`

#### Earnings Per Share - Basic
* `eps_basic(earnings, shares_outstanding)`

#### Diluted Earnings Per Share
* `eps_diluted(earnings, shares_outstanding, diluted_shares)`

#### Pro-Forma Earnings Per Share
* `eps_pro_forma(acquirers_net_income, targets_net_income, incremental_adjustments, shares_outstanding, diluted_shares)`

#### Book Value Earning Per Share
* `eps_book_value(total_equity, preferred_equity, shares_outstanding)`

#### Retained Earnings Per Share
* `eps_retained(retained_earnings, shares_outstanding)`

#### Cash Earnings Per Share
* `eps_cash(operating_cash_flow, shares_outstanding)`

#### Price to Earnings Ratio
* `pe_ratio(price, earnings_per_share)`

#### Price to Earnings to Growth Ratio
* `peg_ratio(price_to_earnings, earnings_growth)`

#### Dividend Payout Ratio
* `dividend_payout(net_dividends, net_income)`

#### Dividend Yield
* `dividend_yield(cash_dividends_per_share, market_value_per_share)`

#### DuPont Analysis
* `du_pont_analysis(profit_margin, total_asset_turnover, financial_leverage)`

#### Enterprise Value
* `ev(market_capitalization, debt, current_cash)`

#### Equity Multiplier
* `equity_multiplier(total_assets, total_stockholders_equity)`

#### Equity Ratio
* `equity_ratio(total_equity, total_assets)`

#### 
* 

#### 
* 
