defmodule Planner.Router do
  use Planner.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Planner do
    pipe_through :api

    get("/", StatusController, :index)

    post("/token/auth", LoginController, :create)
  end
end
