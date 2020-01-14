defmodule AcqdatWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias AcqdatWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint AcqdatWeb.Endpoint

      @default_opts [
        store: :cookie,
        key: "secretkey",
        encryption_salt: "encrypted cookie salt",
        signing_salt: "signing salt"
      ]
      @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

      def signin_guardian(conn, user) do
        conn =
          conn
          |> Plug.Session.call(@signing_opts)
          |> Plug.Conn.fetch_session()
          |> AcqdatWeb.Guardian.Plug.sign_in(user)
          |> Guardian.Plug.VerifySession.call([])
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Acqdat.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Acqdat.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
