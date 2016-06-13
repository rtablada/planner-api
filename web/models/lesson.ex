defmodule Planner.Lesson do
  use Planner.Web, :model

  schema "lessons" do
    field :week, :integer
    field :day, :integer
    field :date, Ecto.Date
    field :image, :string
    field :quote, :string
    belongs_to :instructor, Planner.Instructor

    timestamps
  end

  @required_fields ~w(week day date image quote)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
