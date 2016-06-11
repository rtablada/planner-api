defmodule Planner.User do
  use Planner.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string

    field(:password, :string, virtual: true)

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  # def changeset(model, params \\ :empty) do
  #   model
  #   |> cast(params, @required_fields, @optional_fields)
  # end

  def register_instructor_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email password), ~w())
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
