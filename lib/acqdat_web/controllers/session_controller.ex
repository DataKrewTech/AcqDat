defmodule AcqdatWeb.SessionController do
  use AcqdatWeb, :controller
  use Params
  import AcqdatWeb.Helpers
  alias Acqdat.Context.Account
  alias AcqdatWeb.Guardian

  defparams(
    signin_params(%{
      email!: :string,
      password!: :string
    })
  )

  def new(conn, _params) do
    changeset = signin_params(%{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session}) do
    changeset = signin_params(session)
    verify_session(extract_changeset_data(changeset), conn)
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.session_path(conn, :new))
  end

  defp verify_session({:ok, %{email: email, password: password}}, conn) do
    login(Account.authenticate(email, password), conn)
  end

  defp verify_session({:error, changeset}, conn) do
    conn
    |> put_flash(:error, "Sorry there were some errors !")
    |> render("new.html", changeset: %{changeset | action: :insert})
  end

  defp login({:ok, user}, conn) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: Routes.dryer_path(conn, :index))
  end

  defp login({:error, _}, conn) do
    conn
    |> put_flash(:error, "Incorrect email/password")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
