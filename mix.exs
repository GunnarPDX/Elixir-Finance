defmodule Finance.Mixfile do
  use Mix.Project

  def project do
    [app: :finance,
      version: "0.0.0",
      elixir: "~> 1.7",
      description: "A finance library for elixir.",
      package: package(),
      description: description(),
      deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    A finance library for elixir.

    Credits:
    XIRR by Shubham Gupta --> https://github.com/scripbox/ex-elixir
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Gunnar Rosenberg"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/GunnarPDX/Elixir-Finance"}
    ]
  end

  defp deps do
    [
      {:timex, "~> 3.1"},
      {:ex_doc, "~> 0.12", only: :dev},
      {:benchee, "~> 0.11", only: :dev},
      {:benchee_html, "~> 0.4", only: :dev},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end


end