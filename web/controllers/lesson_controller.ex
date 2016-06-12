defmodule Planner.LessonController do
  use Planner.Web, :controller

  alias Planner.Lesson

  plug :scrub_params, "lesson" when action in [:create, :update]

  def index(conn, _params) do
    lessons = Repo.all(Lesson)
    render(conn, "index.json", lessons: lessons)
  end

  def create(conn, %{"lesson" => lesson_params}) do
    changeset = Lesson.changeset(%Lesson{}, lesson_params)

    case Repo.insert(changeset) do
      {:ok, lesson} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", lesson_path(conn, :show, lesson))
        |> render("show.json", lesson: lesson)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Planner.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lesson = Repo.get!(Lesson, id)
    render(conn, "show.json", lesson: lesson)
  end

  def update(conn, %{"id" => id, "lesson" => lesson_params}) do
    lesson = Repo.get!(Lesson, id)
    changeset = Lesson.changeset(lesson, lesson_params)

    case Repo.update(changeset) do
      {:ok, lesson} ->
        render(conn, "show.json", lesson: lesson)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Planner.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lesson = Repo.get!(Lesson, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(lesson)

    send_resp(conn, :no_content, "")
  end
end
