defmodule Planner.BlockController do
  use Planner.Web, :controller

  alias Planner.Block

  def index(conn, _params) do
    blocks = Repo.all(Block)
    render(conn, "index.json", data: blocks)
  end

  def create(conn, %{"data" => %{
    "type" => "blocks",
    "attributes" => block_params,
    "relationships" => %{
      "lesson" => %{
        "data" => %{
          "type" => "lessons",
          "id" => lesson_id,
        }
      }
    }}}) do
    changeset = Block.changeset(%Block{lesson_id: lesson_id}, block_params)

    case Repo.insert(changeset) do
      {:ok, block} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", block_path(conn, :show, block))
        |> render("show.json", data: block)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Planner.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    block = Repo.get!(Block, id)
    render(conn, "show.json", data: block)
  end

  def update(conn, %{"data" => %{
    "id" => id,
    "type" => "blocks",
    "attributes" => block_params,
    "relationships" => %{
      "lesson" => %{
        "data" => %{
          "type" => "lessons",
          "id" => lesson_id,
        }
      }
    }}}) do
    block = Repo.get!(Block, id)
    changeset = Block.changeset(block, block_params)

    case Repo.update(changeset) do
      {:ok, block} ->
        render(conn, "show.json", data: block)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Planner.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    block = Repo.get!(Block, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(block)

    send_resp(conn, :no_content, "")
  end
end
