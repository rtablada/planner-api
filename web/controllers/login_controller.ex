defmodule Planner.LoginController do
  use Planner.Web, :controller

  alias Planner.Auth

  def create(conn, %{"email" => email, "password" => password}) do
    attempt = Auth.attempt(%{email: email, password: password})

    case attempt do
      {:ok, user} ->
        { :ok, jwt, _} = Guardian.encode_and_sign(user, :token)
        conn
        |> json(%{auth_token: jwt})
      {:error, :unauthorized} ->
        conn
        |> put_status(401)
        |> json(%{errors: [
            %{
              status: 401,
              message: "The password and user email do not match",
            }
          ]})
      {:error, :not_found} ->
        conn
        |> put_status(401)
        |> json(%{errors: [
            %{
              status: 401,
              message: "The user does not exist",
            }
          ]})
    end
  end
end
