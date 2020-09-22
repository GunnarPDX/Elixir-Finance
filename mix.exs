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
      {:decimal, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end


end