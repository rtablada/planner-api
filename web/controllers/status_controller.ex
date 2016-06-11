defmodule Planner.StatusController do
  use Planner.Web, :controller

  def index(conn, _) do
    conn
    |> json(%{
      status: "Ok",
      version: "0.1.0"
    })
  end
end
