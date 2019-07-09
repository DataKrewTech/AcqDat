defmodule AcqdatWeb.API.EnsureAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :acqdat,
    module: AcqdatWeb.Guardian,
    error_handler: AcqdatWeb.API.ErrorHandler

  plug Guardian.Plug.EnsureAuthenticated
end
