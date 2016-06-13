defmodule Planner.Repo.Migrations.CreateLesson do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add :week, :integer
      add :day, :integer
      add :date, :date
      add :image, :string
      add :quote, :string
      add :instructor_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:lessons, [:instructor_id])

  end
end
