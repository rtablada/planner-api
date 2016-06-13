defmodule Planner.Endpoint do
  use Phoenix.Endpoint, otp_app: :planner

  socket "/socket", Planner.UserSocket

  plug CORSPlug

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_planner_key",
    signing_salt: "15mbrfj8"

  plug Planner.Router
end
