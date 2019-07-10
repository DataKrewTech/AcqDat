defmodule AcqdatWeb.API.TokenController do
  use AcqdatWeb, :controller
  alias Acqdat.Context.Account

  def create(conn, %{"email" => email, "password" => password}) do
    case Account.authenticate(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = user |> AcqdatWeb.Guardian.encode_and_sign()

        conn
        |> Plug.Conn.assign(:current_user, user)
        |> put_status(:created)
        |> render("show.json", token: token, user_id: user.id)

      {:error, reason} ->
        handle_unauthenticated(conn, reason)
    end
  end

  def create(conn, %{"email" => ""}) do
    handle_unauthenticated(conn, "Please enter your email and password.")
  end

  def create(conn, %{"email" => _email}) do
    handle_unauthenticated(conn, "Please enter your password.")
  end

  def refresh(conn, %{"token" => current_token}) do
    with {:ok, _claims} <- AcqdatWeb.Guardian.decode_and_verify(current_token),
         {:ok, _, {new_token, new_claims}} <- AcqdatWeb.Guardian.refresh(current_token),
         {:ok, user} <- AcqdatWeb.Guardian.resource_from_claims(new_claims) do
      conn
      |> Plug.Conn.assign(:current_user, user)
      |> put_status(:created)
      |> render("show.json", token: new_token, user_id: user.id)
    else
      {:error, reason} -> handle_unauthenticated(conn, reason)
    end
  end

  defp handle_unauthenticated(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> render("401.json", message: reason)
  end
end
