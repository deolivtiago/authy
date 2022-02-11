defmodule Authy.Repo do
  use Ecto.Repo,
    otp_app: :authy,
    adapter: Ecto.Adapters.Postgres
end
