use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :acqdat, AcqdatWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :acqdat, Acqdat.Repo,
  username: "postgres",
  password: "postgres",
  database: "acqdat_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :acqdat, Acqdat.Mailer,
  adapter: Bamboo.TestAdapter
