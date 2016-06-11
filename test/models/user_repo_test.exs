defmodule Planner.UserRepoTest do
  use Planner.ModelCase
  alias Planner.User

  @valid_attrs %{email: "ryan@example.com", password: "supersecretpass"}

  test "users cannot have the same email" do
    changeset = User.register_instructor_changeset(%User{}, @valid_attrs)
    user = Repo.insert!(changeset)

    changeset = User.register_instructor_changeset(%User{}, @valid_attrs)
    assert({:error, changeset} = Repo.insert(changeset))
    assert({:email, "has already been taken"} in changeset.errors)
  end
end
