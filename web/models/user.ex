defmodule Planner.User do
  use Planner.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string

    field(:password, :string, virtual: true)

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def register_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def register_instructor_changeset(model, params \\ :empty) do
    model
    |> register_changeset(params)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
