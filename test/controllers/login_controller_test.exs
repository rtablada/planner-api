defmodule Planner.LoginControllerTest do
  use Planner.ConnCase

  @user_attrs %{email: "ryan@example.com", password: "mypassword"}

  test "user can login with email and password", %{conn: conn} do
    changeset = Planner.User.register_changeset(%Planner.User{}, @user_attrs)
    user = Planner.Repo.insert!(changeset)

    conn = post(conn, login_path(conn, :create), @user_attrs)

    assert %{"auth_token" => token} = json_response(conn, 200)
    assert {:ok, %{"aud" => "User:" <> id}} = Guardian.decode_and_verify(token)
    assert user.id == String.to_integer(id)
  end

  test "errors when user does not exist", %{conn: conn} do
    conn = post(conn, login_path(conn, :create), @user_attrs)

    assert \
      %{"errors" => [
        %{"status" => 401, "message" => "The user does not exist"}
      ]} = json_response(conn, 401)
  end

  test "errors with invalid password for existing user", %{conn: conn} do
    changeset = Planner.User.register_changeset(%Planner.User{}, @user_attrs)
    Planner.Repo.insert!(changeset)
    invalid_attrs = Map.put(@user_attrs, :password, "invalid")

    conn = post(conn, login_path(conn, :create), invalid_attrs)

    assert \
      %{"errors" => [
        %{"status" => 401, "message" => "The password and user email do not match"}
      ]} = json_response(conn, 401)
  end
end
