defmodule Plustwo.Domain.World.Commands.CreateZone do
  @moduledoc false

  defstruct [
    country_id: "",
    name: "",
  ]

  use Plustwo.Domain, :command
  alias Plustwo.Domain.World.Schemas.Zone

  @doc """
  Validate data before inserting.
  """
  def changeset(%Zone{} = changeset, attrs) do
    changeset
    |> cast(attrs, ~w(country_id name))
    |> validate_required([:country_id, :name])
    |> foreign_key_constraint(:country_id, message: "does not exist")
    |> unique_constraint(:name, name: :name, message: "already exists")
  end
end
