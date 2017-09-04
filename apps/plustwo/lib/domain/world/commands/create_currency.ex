defmodule Plustwo.Domain.World.Commands.CreateCurrency do
  @moduledoc false

  defstruct [
    code: "",
    name: "",
  ]

  use Plustwo.Domain, :command
  alias Plustwo.Domain.World.Schemas.Currency

  @doc """
  Downcase currency code.
  """
  def downcase_code(%{code: code} = currency) do
    Map.put(currency, :code, String.downcase(code))
  end

  @doc """
  Validate data before inserting.
  """
  def changeset(%Currency{} = changeset, attrs) do
    changeset
    |> cast(attrs, ~w(code name))
    |> validate_required([:code, :name])
    |> unique_constraint(:code, name: :ode, message: "already exists")
  end
end
