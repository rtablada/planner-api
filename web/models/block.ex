defmodule Planner.Block do
  use Planner.Web, :model

  schema "blocks" do
    field :title, :string
    field :estimated_time, :integer
    field :completed, :boolean, default: false
    field :time_elapsed, :integer
    belongs_to :lesson, Planner.Lesson

    timestamps
  end

  @required_fields ~w(title estimated_time completed time_elapsed)
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
