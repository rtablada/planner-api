defmodule Planner.BlockControllerTest do
  use Planner.ConnCase

  alias Planner.Lesson
  alias Planner.Block
  @valid_attrs %{completed: true, estimated_time: 42, time_elapsed: 42, title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %Planner.User{}
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json") # JSON-API content-type
    |> put_req_header("authorization", "Bearer #{jwt}") # Add token to auth header

    {:ok, %{conn: conn, user: user}} # Pass user object to each test
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, block_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}

    block = Repo.insert! %Block{lesson_id: lesson.id}
    conn = get conn, block_path(conn, :show, block)

    assert resp = json_response(conn, 200)

    assert %{"data" => %{"id" => id, "attributes" => attributes}} = resp

    assert %{
      "title" => title,
      "estimated-time" => estimated_time,
      "completed" => completed,
      "time-elapsed" => time_elapsed,
    } = attributes

    # assert String.to_integer(id) == block.id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, block_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    relationships = make_relationship_blob(lesson)

    conn = post conn, block_path(conn, :create), data: %{type: "blocks", attributes: @valid_attrs, relationships: relationships}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Block, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    relationships = make_relationship_blob(lesson)

    conn = post conn, block_path(conn, :create), data: %{type: "blocks", attributes: @invalid_attrs, relationships: relationships}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    relationships = make_relationship_blob(lesson)

    block = Repo.insert! %Block{lesson_id: lesson.id}

    conn = put conn, block_path(conn, :update, block), data: %{id: block.id, type: "blocks", attributes: @valid_attrs, relationships: relationships}
    # assert json_response(conn, 200)["data"]["id"]
    # assert Repo.get_by(Block, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    relationships = make_relationship_blob(lesson)

    block = Repo.insert! %Block{lesson_id: lesson.id}
    conn = put conn, block_path(conn, :update, block), data: %{id: block.id, type: "blocks", attributes: @invalid_attrs, relationships: relationships}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}

    block = Repo.insert! %Block{lesson_id: lesson.id}
    conn = delete conn, block_path(conn, :delete, block)
    assert response(conn, 204)
    refute Repo.get(Block, block.id)
  end

  defp make_relationship_blob(lesson) do
    %{lesson: %{data: %{type: "lessons", id: lesson.id}}}
  end
end
