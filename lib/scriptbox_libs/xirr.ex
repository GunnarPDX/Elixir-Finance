defmodule ExXirr do
  @moduledoc """
  Library to calculate XIRR and absolute rate of return
  through the Newton Raphson method.
  """

  @max_error 1.0e-3
  @days_in_a_year 365

  # Public API

  @doc """
  Function to calculate the rate of return for a given array of
  dates and values.
  ## Examples
      iex> d = [{1985, 1, 1}, {1990, 1, 1}, {1995, 1, 1}]
      iex> v = [1000, -600, -200]
      iex> ExXirr.xirr(d,v)
      {:ok, -0.034592}
  """
  @spec xirr([Date.t()], [number]) :: float
  def xirr(dates, values) when length(dates) != length(values) do
    {:error, "Date and Value collections must have the same size"}
  end

  def xirr(dates, values) when length(dates) < 10 do
    LegacyFinance.xirr(dates, values)
  end

  def xirr(dates, values) do
    dates = Enum.map(dates, &Date.from_erl!(&1))
    min_date = dates |> List.first()
    {dates, values, dates_values} = compact_flow(Enum.zip(dates, values), min_date)

    cond do
      !verify_flow(values) ->
        {:error, "Values should have at least one positive or negative value."}

      length(dates) - length(values) == 0 && verify_flow(values) ->
        calculate(:xirr, dates_values, [], guess_rate(dates, values), 0)

      true ->
        {:error, "Uncaught error"}
    end
  rescue
    _ ->
      {:error, 0.0}
  end

  @doc """
  Function to calculate the absolute rate of return for a given array
  of dates and values.
  ## Examples
      iex> d = [{1985, 1, 1}, {1990, 1, 1}, {1995, 1, 1}]
      iex> v = [1000, -600, -200]
      iex> {:ok, rate} = ExXirr.xirr(d,v)
      iex> ExXirr.absolute_rate(rate, 50)
      {:ok, -0.48}
  """
  @spec absolute_rate(float(), integer()) :: {:ok, float()} | {:error, String.t()}
  def absolute_rate(0, _), do: {:error, "Rate is 0"}

  def absolute_rate(rate, days) do
    try do
      if days < @days_in_a_year do
        {:ok, ((:math.pow(1 + rate, days / @days_in_a_year) - 1) * 100) |> Float.round(2)}
      else
        {:ok, (rate * 100) |> Float.round(2)}
      end
    rescue
      _ ->
        {:error, 0.0}
    end
  end

  # Private API

  @spec pmap(list(tuple()), fun()) :: Enum.t()
  defp pmap(collection, function) do
    me = self()

    collection
    |> Enum.map(fn element -> spawn_link(fn -> send(me, {self(), function.(element)}) end) end)
    |> Enum.map(fn pid ->
      receive do
        {^pid, result} -> result
      end
    end)
  end

  @spec power_of(float(), Fraction.t()) :: float()
  defp power_of(rate, fraction) when rate < 0 do
    :math.pow(-rate, Fraction.to_float(fraction)) * :math.pow(-1, fraction.num)
  end

  defp power_of(rate, fraction) do
    :math.pow(rate, Fraction.to_float(fraction))
  end

  @spec xirr_reduction({Fraction.t(), float(), float()}) :: float()
  defp xirr_reduction({fraction, value, rate}) do
    value / power_of(1.0 + rate, fraction)
  end

  @spec dxirr_reduction({Fraction.t(), float(), float()}) :: float()
  defp dxirr_reduction({fraction, value, rate}) do
    -value * Fraction.to_float(fraction) * power_of(1.0 + rate, Fraction.negative(fraction)) *
      :math.pow(1.0 + rate, -1)
  end

  @spec compact_flow(list(), Date.t()) :: tuple()
  defp compact_flow(dates_values, min_date) do
    flow = Enum.reduce(dates_values, %{}, &organize_value(&1, &2, min_date))
    {Map.keys(flow), Map.values(flow), Enum.filter(flow, &(elem(&1, 1) != 0))}
  end

  @spec organize_value(tuple(), map(), Date.t()) :: map()
  defp organize_value(date_value, dict, min_date) do
    {date, value} = date_value

    fraction = %Fraction{
      num: Date.diff(date, min_date),
      den: 365.0
    }

    Map.update(dict, fraction, value, &(value + &1))
  end

  @spec verify_flow(list(float())) :: boolean()
  defp verify_flow(values) do
    {min, max} = Enum.min_max(values)
    min < 0 && max > 0
  end

  @spec guess_rate([Date.t()], [number]) :: float
  defp guess_rate(dates, values) do
    {min_value, max_value} = Enum.min_max(values)
    period = 1 / (length(dates) - 1)
    multiple = 1 + abs(max_value / min_value)
    rate = :math.pow(multiple, period) - 1
    Float.round(rate, 6)
  end

  @spec reduce_date_values(list(), float()) :: tuple()
  defp reduce_date_values(dates_values, rate) do
    calculated_xirr =
      dates_values
      |> pmap(fn x ->
        {
          elem(x, 0),
          elem(x, 1),
          rate
        }
      end)
      |> pmap(&xirr_reduction/1)
      |> Enum.sum()
      |> Float.round(6)

    calculated_dxirr =
      dates_values
      |> pmap(fn x ->
        {
          elem(x, 0),
          elem(x, 1),
          rate
        }
      end)
      |> pmap(&dxirr_reduction/1)
      |> Enum.sum()
      |> Float.round(6)

    {calculated_xirr, calculated_dxirr}
  end

  @spec calculate(atom(), list(), float(), float(), integer()) ::
          {:ok, float()} | {:error, String.t()}
  defp calculate(:xirr, _, 0.0, rate, _), do: {:ok, Float.round(rate, 6)}
  defp calculate(:xirr, _, _, -1.0, _), do: {:error, "Could not converge"}
  defp calculate(:xirr, _, _, _, 300), do: {:error, "I give up"}

  defp calculate(:xirr, dates_values, _, rate, tries) do
    {xirr, dxirr} = reduce_date_values(dates_values, rate)

    new_rate =
      if dxirr < 0.0 do
        rate
      else
        rate - xirr / dxirr
      end

    diff = Kernel.abs(new_rate - rate)
    diff = if diff < @max_error, do: 0.0
    tries = tries + 1
    calculate(:xirr, dates_values, diff, new_rate, tries)
  end
end