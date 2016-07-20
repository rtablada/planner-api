defmodule Planner.ReviewTopicController do
  use Planner.Web, :controller

  alias Planner.ReviewTopic
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    review_topics = Repo.all(ReviewTopic)
    render(conn, "index.json", data: review_topics)
  end

  def create(conn, %{"data" => data = %{
    "type" => "review-topics",
    "attributes" => review_topic_params,
    "relationships" => %{
      "lesson" => %{
        "data" => %{
          "type" => "lessons",
          "id" => lesson_id,
        }
      }
    }}}) do
    changeset = ReviewTopic.changeset(%ReviewTopic{lesson_id: String.to_integer(lesson_id)}, review_topic_params)

    case Repo.insert(changeset) do
      {:ok, review_topic} ->
        review_topic = Repo.preload(review_topic, :lesson)

        conn
        |> put_status(:created)
        |> put_resp_header("location", review_topic_path(conn, :show, review_topic))
        |> render("show.json", data: review_topic)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Planner.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    review_topic = Repo.get!(ReviewTopic, id)
    render(conn, "show.json", data: review_topic)
  end

  def update(conn, %{"data" => %{
    "id" => id,
    "type" => "review-topic",
    "attributes" => review_topic_params,
    "relationships" => %{
      "lesson" => %{
        "data" => %{
          "type" => "lessons",
          "id" => lesson_id,
        }
      }
    }}}) do
    review_topic = Repo.get!(ReviewTopic, id)
    review_topic_params = Map.put(review_topic_params, "lesson_id", String.to_integer(lesson_id))
    changeset = Block.changeset(review_topic, review_topic_params)

    case Repo.update(changeset) do
      {:ok, review_topic} ->
        review_topic = Repo.preload(review_topic, :lesson)
        render(conn, "show.json", data: review_topic)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Planner.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    review_topic = Repo.get!(ReviewTopic, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(review_topic)

    send_resp(conn, :no_content, "")
  end

end
