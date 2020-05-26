# ExXirr
[![codecov](https://codecov.io/gh/scripbox/ex-xirr/branch/master/graph/badge.svg)](https://codecov.io/gh/scripbox/ex-xirr) ![Hex.pm](https://img.shields.io/hexpm/dt/ex_xirr.svg) ![Travis](https://img.shields.io/travis/scripbox/ex-xirr.svg)

A library to calculate xirr through the Newton Raphson using parallel processes.

## Usage

    iex> d = [{1985, 1, 1}, {1990, 1, 1}, {1995, 1, 1}]
    iex> v = [1000, -600, -200]
    iex> ExXirr.xirr(d,v)
    {:ok, -0.034592}


## Installation

The package can be installed as:

  1. Add ex_xirr to your list of dependencies in `mix.exs`:

      ```ex
      def deps do
        [{:ex_xirr, "~> 1.0.0"}]
      end
      ```

  2. Ensure ex_xirr is started before your application:

      ```ex
      def application do
        [applications: [:ex_xirr]]
      end
      ```
## Test

- Run the test suite using the following
    ```
    MIX_ENV=test mix test
    ```

## Benchmarks

- We use benchee for the benchmark tests. Run it using the following
    ```
    mix run test/xirr_comparison_bench.exs
    ```
- The reports are available [here](https://htmlpreview.github.io/?https://github.com/scripbox/ex-xirr/blob/master/benchmarks/output/results.html).

## Credits

This application is built on the fantastic [finance-elixir](https://github.com/tubedude/finance-elixir) package. Many thanks to [tubedude](https://github.com/tubedude) for his work.