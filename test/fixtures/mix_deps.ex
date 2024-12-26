defmodule Fixtures.MixDeps do
  def deps do
    [
      %Mix.Dep{
        app: :ash,
        opts: [
          dest: "deps/ash"
        ],
        top_level: true
      },
      %Mix.Dep{
        app: :phoenix,
        opts: [
          dest: "deps/phoenix"
        ],
        top_level: true
      },
      %Mix.Dep{
        app: :money,
        opts: [
          dest: "deps/money"
        ],
        top_level: true
      }
    ]
  end
end
