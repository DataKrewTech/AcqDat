defmodule Acqdat.Repo do
  use Ecto.Repo,
    otp_app: :acqdat,
    adapter: Ecto.Adapters.Postgres
end
