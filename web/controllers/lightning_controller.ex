defmodule Planner.LightningController do
  use Plug.Builder
  plug Plug.Static,
    at: "/",
    from: "./assets"
  plug :not_found

  import Exredis
  import Phoenix.Controller

  def assets(conn, _) do
    {:ok, client} = Exredis.start_link
    html(conn, "result")
    #
    # sha = client
    #         |> Exredis.query(["GET", "planning:index:current"])
    # result = client
    #         |> Exredis.query(["GET", "planning:index:#{sha}"])

  end
end
