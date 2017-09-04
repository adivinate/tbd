defmodule Plustwo.Domain.World.Commands.CreateLocale do
  @moduledoc false

  defstruct [
    code: "",
    name: "",
  ]

  use Plustwo.Domain, :command
  alias Plustwo.Domain.World.Schemas.Locale

  @doc """
  Downcase locale code.
  """
  def downcase_code(%{code: code} = locale) do
    Map.put(locale, :code, String.downcase(code))
  end

  @doc """
  Validate data before inserting.
  """
  def changeset(%Locale{} = changeset, attrs) do
    changeset
    |> cast(attrs, ~w(code name))
    |> validate_required([:code, :name])
    |> unique_constraint(:code, name: :code, message: "already exists")
  end
end
