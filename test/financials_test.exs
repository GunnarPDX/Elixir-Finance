defmodule FinancialsTest do

  use ExUnit.Case
  doctest Financials

  alias Decimal, as: D
  alias Financials, as: F

  D.Context.set(
    %D.Context{
      D.Context.get()
    | flags: [:rounded],
      precision: 2,
      rounding: :half_up,
      traps: [:invalid_operation, :division_by_zero]
    }
  )

  @x1 D.from_float(245_004_340.17)
  @x2 D.from_float(45_430_340.96)
  @x3 D.from_float(35_000_000.77)
  @x4 D.from_float(204_670.83)
  @x5 D.from_float(120_000.34)


  @zero D.new(0)
  @days 365

  describe "Financials" do

    test "net_income" do
      {status, val} = F.net_income(@x1, @x2)

      assert {status, D.to_float(val)} == {:ok, 199573999.21}
    end

    test "earnings" do
      {status, val} = F.earnings(@x1, @x2)

      assert {status, D.to_float(val)} == {:ok, 199573999.21}
    end

    test "retained_earnings" do
      {status, val} = F.retained_earnings(@x1, @x2, @x3, @zero)

      assert {status, D.to_float(val)} == {:ok, 255434680.36}
    end

    test "ocf" do
      {status, val} = F.ocf(@x2, @x1, @x3, @zero)

      assert {status, D.to_float(val)} == {:ok, 255434680.36}
    end

    test "ror" do
      {status, val} = F.ror(@x2, @x1)

      assert {status, D.to_float(val)} == {:ok, 0.1854266782722194418830404999}
    end

    test "ror / 0" do
      {status, val} = F.ror(@x2, @zero)

      assert {status, val} == {:error, "sales_revenue can't equal zero (Divide by zero error)"}
    end

    test "ros" do
      {status, val} = F.ros(@x2, @x1)

      assert {status, D.to_float(val)} == {:ok, 0.18542667827221945}
    end

    test "cogs" do
      {status, val} = F.cogs(@x1, @x2, @x3)

      assert {status, D.to_float(val)} == {:ok, 255434680.36}
    end

    test "ebit" do
      {status, val} = F.ebit(@x1, @x2, @x3)

      assert {status, D.to_float(val)} == {:ok, 234573999.98}
    end

    test "ebita" do
      {status, val} = F.ebita(@x1, @x2, @x3, @x4)

      assert {status, D.to_float(val)} == {:ok, 234778670.81}
    end

    test "ebitda" do
      {status, val} = F.ebitda(@x1, @x2, @x3, @x4, @x5)

      assert {status, D.to_float(val)} == {:ok, 325759353.07}
    end

    test "receivable_turnover_ratio" do
      {status, val} = F.receivable_turnover_ratio(@x1, @x2)

      assert {status, D.to_float(val)} == {:ok, 5.3929672327513165}
    end


  end


end