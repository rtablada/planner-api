defmodule Planner.Repo.Migrations.CreateReviewTopic do
  use Ecto.Migration

  def change do
    create table(:review_topics) do
      add :name, :string
      add :done, :boolean, default: false
      add :lesson_id, references(:lessons, on_delete: :nothing)

      timestamps
    end
    create index(:review_topics, [:lesson_id])

  end
end
