defmodule Planner.LoginControllerTest do
  use Planner.ConnCase

  @user_attrs %{email: "ryan@example.com", password: "mypassword"}

  test "user can login with email and password", %{conn: conn} do
    changeset = Planner.User.register_changeset(%Planner.User{}, @user_attrs)
    user = Planner.Repo.insert!(changeset)

    input = Map.put(@user_attrs, :grant_type, "password")
    input = Map.put(input, :username, @user_attrs[:email])

    conn = post(conn, login_path(conn, :create), input)

    assert %{"access_token" => token} = json_response(conn, 200)
    assert {:ok, %{"aud" => "User:" <> id}} = Guardian.decode_and_verify(token)
    assert user.id == String.to_integer(id)
  end

  test "errors when user does not exist", %{conn: conn} do
    input = Map.put(@user_attrs, :grant_type, "password")
    input = Map.put(input, :username, @user_attrs[:email])

    conn = post(conn, login_path(conn, :create), input)

    assert \
      %{"errors" => [
        %{"status" => 401, "message" => "The user does not exist"}
      ]} = json_response(conn, 401)
  end

  test "errors with invalid password for existing user", %{conn: conn} do
    changeset = Planner.User.register_changeset(%Planner.User{}, @user_attrs)
    Planner.Repo.insert!(changeset)
    input = Map.put(@user_attrs, :password, "invalid")
    input = Map.put(input, :grant_type, "password")
    input = Map.put(input, :username, @user_attrs[:email])

    conn = post(conn, login_path(conn, :create), input)

    assert \
      %{"errors" => [
        %{"status" => 401, "message" => "The password and user email do not match"}
      ]} = json_response(conn, 401)
  end
end
