defmodule Planner.UserTest do
  use Planner.ModelCase

  alias Planner.User

  @valid_attrs %{email: "ryan@example.com", password: "mypassword"}
  @invalid_attrs %{}

  test "instructor registration with valid attributes" do
    changeset = User.register_instructor_changeset(%User{}, @valid_attrs)

    assert changeset.valid?
  end

  test "instructor registration with invalid attributes" do
    changeset = User.register_instructor_changeset(%User{}, @invalid_attrs)

    refute changeset.valid?
  end

  test "instructor registration with invalid email" do
    attrs = Map.put(@valid_attrs, :email, "ryan")
    changeset = User.register_instructor_changeset(%User{}, attrs)

    refute changeset.valid?
  end
end
