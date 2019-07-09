defmodule AcqdatWeb.Auth.BearerAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :acqdat,
    module: AcqdatWeb.Guardian,
    error_handler: AcqdatWeb.API.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
end
