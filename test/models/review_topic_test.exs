defmodule Planner.ReviewTopicTest do
  use Planner.ModelCase

  alias Planner.ReviewTopic

  @valid_attrs %{done: true, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ReviewTopic.changeset(%ReviewTopic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ReviewTopic.changeset(%ReviewTopic{}, @invalid_attrs)
    refute changeset.valid?
  end
end
