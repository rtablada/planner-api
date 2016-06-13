defmodule Planner.LessonTest do
  use Planner.ModelCase

  alias Planner.Lesson

  @valid_attrs %{date: "2010-04-17", day: 42, image: "some content", quote: "some content", week: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Lesson.changeset(%Lesson{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Lesson.changeset(%Lesson{}, @invalid_attrs)
    refute changeset.valid?
  end
end
