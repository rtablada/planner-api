defmodule Planner.LightningController do
  use Plug.Builder
  plug Plug.Static,
    at: "/",
    from: "./assets"
  plug :not_found

  import Exredis
  import Phoenix.Controller

  def not_found(conn, _) do
    {:ok, client} = Exredis.start_link

    sha = client
            |> Exredis.query(["GET", "planner:index:current"])
    result = client
            |> Exredis.query(["GET", "planner:index:#{sha}"])

    html(conn, result)
  end
end
