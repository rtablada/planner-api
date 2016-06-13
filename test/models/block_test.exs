defmodule Planner.BlockTest do
  use Planner.ModelCase

  alias Planner.Block

  @valid_attrs %{completed: true, estimated_time: 42, time_elapsed: 42, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Block.changeset(%Block{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Block.changeset(%Block{}, @invalid_attrs)
    refute changeset.valid?
  end
end
