defmodule SoleilDemo.Repo do
  use Ecto.Repo,
    otp_app: :soleil_demo,
    adapter: Ecto.Adapters.SQLite3
end
