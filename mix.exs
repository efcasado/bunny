defmodule Bunny.Mixfile do
  use Mix.Project

  def project do
    [app: :bunny,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger],
     mod: {Bunny, []}]
  end

  defp deps do
    [
      {:amqp,
       git: "https://github.com/efcasado/amqp",
       branch: "rmq-client-3.6.7-pre.1"}
    ]
  end
end
