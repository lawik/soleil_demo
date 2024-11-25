# Used by "mix format"
[
  import_deps: [:ecto, :ecto_sql],
  subdirectories: ["priv/*/migrations"],
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "rootfs_overlay/etc/iex.exs",
    "priv/*/seeds.exs"
  ]
]
