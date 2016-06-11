defmodule Planner.UserTest do
  use Planner.ModelCase

  alias Planner.User

  @valid_attrs %{email: "ryan@example.com", password: "mypassword"}
  @invalid_attrs %{}

  test "instructor registration with valid attributes" do
    changeset = User.register_instructor_changeset(%User{}, @valid_attrs)

    assert(changeset.valid?)
  end

  test "instructor registration with invalid attributes" do
    changeset = User.register_instructor_changeset(%User{}, @invalid_attrs)

    refute(changeset.valid?)
  end

  test "instructor registration with invalid email" do
    attrs = Map.put(@valid_attrs, :email, "ryan")
    changeset = User.register_instructor_changeset(%User{}, attrs)

    refute(changeset.valid?)
  end

  test "registration hashes password" do
    changeset = User.register_changeset(%User{}, @valid_attrs)

    %{password: password, password_hash: password_hash} = changeset.changes

    assert(changeset.valid?)
    assert(Comeonin.Bcrypt.checkpw(password, password_hash))
  end
end
