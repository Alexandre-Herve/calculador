defmodule Calculador.User do
  use Calculador.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> unique_constraint(:email)
  end
end
