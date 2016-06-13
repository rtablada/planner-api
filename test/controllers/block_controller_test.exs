defmodule Planner.BlockControllerTest do
  use Planner.ConnCase

  alias Planner.Block
  @valid_attrs %{completed: true, estimated_time: 42, time_elapsed: 42, title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, block_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    block = Repo.insert! %Block{}
    conn = get conn, block_path(conn, :show, block)
    assert json_response(conn, 200)["data"] == %{"id" => block.id,
      "title" => block.title,
      "estimated_time" => block.estimated_time,
      "completed" => block.completed,
      "time_elapsed" => block.time_elapsed,
      "lesson_id" => block.lesson_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, block_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, block_path(conn, :create), block: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Block, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, block_path(conn, :create), block: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    block = Repo.insert! %Block{}
    conn = put conn, block_path(conn, :update, block), block: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Block, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    block = Repo.insert! %Block{}
    conn = put conn, block_path(conn, :update, block), block: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    block = Repo.insert! %Block{}
    conn = delete conn, block_path(conn, :delete, block)
    assert response(conn, 204)
    refute Repo.get(Block, block.id)
  end
end
