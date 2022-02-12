defmodule AuthyWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :authy,
    error_handler: AuthyWeb.Auth.ErrorHandler,
    module: AuthyWeb.Auth.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
