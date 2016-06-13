defmodule Planner.LessonControllerTest do
  use Planner.ConnCase

  alias Planner.Lesson
  @valid_attrs %{date: "2010-04-17", day: 42, image: "some content", quote: "some content", week: 42}
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
    conn = get(conn, lesson_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    block = Repo.insert! %Planner.Block{lesson_id: lesson.id}
    conn = get(conn, lesson_path(conn, :show, lesson))

    assert resp = json_response(conn, 200)

    assert %{"data" => %{
      "id" => id, "attributes" => attributes,
      "relationships" => %{
        "blocks" => %{"data" => blocks}
      }
    }} = resp

    [%{"id" => block_id}] = blocks

    assert attributes == %{
      "week" => lesson.week,
      "day" => lesson.day,
      "date" => lesson.date,
      "image" => lesson.image,
      "quote" => lesson.quote
    }

    assert String.to_integer(block_id) == block.id
    assert String.to_integer(id) == lesson.id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get(conn, lesson_path(conn, :show, -1))
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post(conn, lesson_path(conn, :create), data: %{type: "lessons", attributes: @valid_attrs})

    assert id = json_response(conn, 201)["data"]["id"]
    assert lesson = Repo.get_by!(Lesson, @valid_attrs)

    assert lesson.id == String.to_integer(id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, lesson_path(conn, :create), data: %{type: "lessons", attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    conn = put conn, lesson_path(conn, :update, lesson), data: %{"id": lesson.id,type: "lessons", attributes: @valid_attrs}

    assert id = json_response(conn, 200)["data"]["id"]
    assert lesson = Repo.get_by!(Lesson, @valid_attrs)

    assert lesson.id == String.to_integer(id)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    conn = put conn, lesson_path(conn, :update, lesson), data: %{"id": lesson.id,type: "lessons", attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    lesson = Repo.insert! %Lesson{}
    conn = delete conn, lesson_path(conn, :delete, lesson)
    assert response(conn, 204)
    refute Repo.get(Lesson, lesson.id)
  end
end
