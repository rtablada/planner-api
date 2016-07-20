defmodule Planner.ReviewTopicControllerTest do
  use Planner.ConnCase

  alias Planner.ReviewTopic
  alias Planner.Repo

  @valid_attrs %{done: true, name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    lesson = Repo.insert!(%Planner.Lesson{})

    %{
      "lesson" => %{
        "data" => %{
          "type" => "lesson",
          "id" => lesson.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, review_topic_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    review_topic = Repo.insert! %ReviewTopic{}
    conn = get conn, review_topic_path(conn, :show, review_topic)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{review_topic.id}"
    assert data["type"] == "review-topic"
    assert data["attributes"]["name"] == review_topic.name
    assert data["attributes"]["done"] == review_topic.done
    assert data["attributes"]["lesson_id"] == review_topic.lesson_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, review_topic_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, review_topic_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "review-topic",
  #       "attributes" => @valid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(ReviewTopic, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, review_topic_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "review-topic",
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   review_topic = Repo.insert! %ReviewTopic{}
  #   conn = put conn, review_topic_path(conn, :update, review_topic), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "review-topic",
  #       "id" => review_topic.id,
  #       "attributes" => @valid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(ReviewTopic, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   review_topic = Repo.insert! %ReviewTopic{}
  #   conn = put conn, review_topic_path(conn, :update, review_topic), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "review-topic",
  #       "id" => review_topic.id,
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   review_topic = Repo.insert! %ReviewTopic{}
  #   conn = delete conn, review_topic_path(conn, :delete, review_topic)
  #   assert response(conn, 204)
  #   refute Repo.get(ReviewTopic, review_topic.id)
  # end

end
