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
    resources("/lessons", LessonController, except: [:new, :edit, :create, :delete, :update])
    resources("/blocks", BlockController, except: [:new, :edit, :create, :delete, :update])
    resources("/review-topics", ReviewTopicController, except: [:new, :edit, :create, :delete, :update])
  end

  scope "/api", Planner do
    pipe_through :api_auth

    resources("/users", UserController, except: [:new, :edit])
    resources("/lessons", LessonController, except: [:index, :show, :new, :edit])
    resources("/blocks", BlockController, except: [:index, :show, :new, :edit])
    resources("/review-topics", ReviewTopicController, except: [:index, :show, :new, :edit])
  end

  scope "/", Planner do
    get "/*catch_all", LightningController, :assets
  end
end
