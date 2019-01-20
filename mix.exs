defmodule Thief.MixProject do
  use Mix.Project

   def project() do
    [
      app: :thief,
      version: "0.1.0",
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Thief",
      source_url: "https://github.com/TheWaggle/Thief.git"
    ]
    end

    defp description() do
      " This Project is Scrape and get image links."
    end

    defp package() do
      [
          name: "thief",
          maintainers: ["YOSUKENAKAO.me"],
          licenses: ["MIT"],
          links: %{"GitHub" => "https://github.com/TheWaggle/Thief.git"}
      ]
    end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.20.4"},
      {:httpoison, "~> 1.5"},
      {:ex_doc, "~> 0.19.2", only: :dev},
      {:earmark, ">= 0.0.0"},
    ]
  end
end
