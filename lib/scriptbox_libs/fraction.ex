defmodule Fraction do
  @moduledoc """
  Module to handle fractions
  """

  @typedoc """
   Rational numbers (num/den)
  """
  @type t :: %Fraction{
               num: integer,
               den: non_neg_integer
             }

  defstruct num: 0, den: 1

  @doc """
  Function to convert a Fraction struct to negative
  ## Examples
      iex> fraction = %Fraction{num: 2, den: 4}
      iex> Fraction.negative(fraction)
      %Fraction{num: -2, den: 4}
  """
  @spec negative(t()) :: t()
  def negative(%Fraction{} = fraction) do
    %Fraction{num: -fraction.num, den: fraction.den}
  end

  @doc """
  Function to convert Fraction struct to a floating point number
  Returns floating point number.
  ## Examples
      iex> fraction = %Fraction{num: 3, den: 6}
      iex> Fraction.to_float(fraction)
      0.5
  """
  @spec to_float(t()) :: float()
  def to_float(%Fraction{} = fraction) do
    fraction.num / fraction.den
  end
end