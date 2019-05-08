defmodule AcqdatWeb.AuthenticationPipe do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :acqdat

  plug(Guardian.Plug.VerifySession)
  plug(Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"})
  plug(Guardian.Plug.LoadResource, allow_blank: false)
end
