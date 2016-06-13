defmodule Planner.Repo.Migrations.CreateBlock do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :title, :string
      add :estimated_time, :integer
      add :completed, :boolean, default: false
      add :time_elapsed, :integer
      add :lesson_id, references(:lessons, on_delete: :nothing)

      timestamps
    end
    create index(:blocks, [:lesson_id])

  end
end
