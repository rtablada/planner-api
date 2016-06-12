defmodule Planner.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Planner.Repo
  alias Planner.User

  @moduledoc """
  Attempts to login a user by email and password.

  Returns ok and the user if auth succeeds
  Returns {:error, :unauthorized} if the user exists but the password does not match
  Returns {:error, :not_found} if the user could not be found with a given email
  """
  def attempt(%{email: email, password: password}) do
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end
end
