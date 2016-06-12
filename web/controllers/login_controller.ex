defmodule Planner.LoginController do
  use Planner.Web, :controller

  alias Planner.Auth

  def create(conn, %{"username" => email, "password" => password, "grant_type" => "password",}) do
    attempt = Auth.attempt(%{email: email, password: password})

    case attempt do
      {:ok, user} ->
        { :ok, jwt, _} = Guardian.encode_and_sign(user, :token)
        conn
        |> json(%{access_token: jwt})
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

  def create(conn, _) do
    conn
    |> put_status(400)
    |> json(%{errors: [
        %{
          status: 400,
          message: "Invalid grant or missing username or password.",
        }
      ]})
  end
end
