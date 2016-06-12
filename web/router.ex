defmodule Planner.Router do
  use Planner.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", Planner do
    pipe_through :api

    get("/", StatusController, :index)

    post("/token", LoginController, :create)
  end

  scope "/api", Planner do
    pipe_through :api_auth

    resources("/lessons", LessonController, except: [:new, :edit])
  end
end
