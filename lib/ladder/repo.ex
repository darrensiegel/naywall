defmodule Ladder.Repo do
  use Ecto.Repo,
    otp_app: :ladder,
    adapter: Ecto.Adapters.Postgres
end
