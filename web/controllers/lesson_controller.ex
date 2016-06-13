defmodule Planner.LessonController do
  use Planner.Web, :controller

  alias Planner.Lesson

  def index(conn, _params) do
    lessons = Repo.all(Lesson)
    lessons = Repo.preload(lessons, :blocks)
    render(conn, "index.json", data: lessons)
  end

  def create(conn, %{"data" => %{"type" => "lessons", "attributes" => lesson_params}}) do
    changeset = Lesson.changeset(%Lesson{}, lesson_params)

    case Repo.insert(changeset) do
      {:ok, lesson} ->
        lesson = Repo.preload(lesson, :blocks)

        conn
        |> put_status(:created)
        |> put_resp_header("location", lesson_path(conn, :show, lesson))
        |> render("show.json", data: lesson)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Planner.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lesson = Repo.get!(Lesson, id)
    lesson = Repo.preload(lesson, :blocks)

    render(conn, "show.json", data: lesson)
  end

  def update(conn, %{"data" => %{"id" => id, "type" => "lessons", "attributes" => lesson_params}}) do
    lesson = Repo.get!(Lesson, id)
    changeset = Lesson.changeset(lesson, lesson_params)

    case Repo.update(changeset) do
      {:ok, lesson} ->
        lesson = Repo.preload(lesson, :blocks)

        render(conn, "show.json", data: lesson)
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
