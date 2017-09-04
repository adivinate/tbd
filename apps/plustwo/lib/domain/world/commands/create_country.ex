defmodule Plustwo.Domain.World.Commands.CreateCountry do
  @moduledoc false

  defstruct [
    code: "",
    name: "",
    lname: "",
  ]

  use Plustwo.Domain, :command
  alias Plustwo.Domain.World.Schemas.Country

  @doc """
  Assign lowercase country name.
  """
  def assign_lname(%{name: name} = country) do
    Map.put(country, :lname, String.downcase(name))
  end

  @doc """
  Downcase country code.
  """
  def downcase_code(%{code: code} = country) do
    Map.put(country, :code, String.downcase(code))
  end

  @doc """
  Validate data before inserting.
  """
  def changeset(%Country{} = changeset, attrs) do
    changeset
    |> cast(attrs, ~w(code name lname))
    |> validate_required([:code, :name, :lname])
    |> unique_constraint(:code, name: :code, message: "already exists")
  end
end
