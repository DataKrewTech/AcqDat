defmodule AcqdatWeb.AuthErrorHandler do
  @moduledoc """
  Defines functions for handling authentication errors.
  """
  use AcqdatWeb, :controller
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  @spec auth_error(Plug.Conn.t(), any(), any()) :: Plug.Conn.t()
  def auth_error(conn, _, _opts) do
    conn
    |> put_flash(:error, "Sign in to continue")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
