defmodule Planner.ReviewTopic do
  use Planner.Web, :model

  schema "review_topics" do
    field :name, :string
    field :done, :boolean, default: false
    belongs_to :lesson, Planner.Lesson

    timestamps
  end

  @required_fields ~w(name done)
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
