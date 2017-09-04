defmodule Plustwo.Domain.World.Commands.CreateTimezone do
  @moduledoc false

  defstruct [
    zone_id: "",
    abbreviation: "",
    time_start: "",
    gmt_offset: "",
    dst: "",
  ]

  use Plustwo.Domain, :command
  alias Plustwo.Domain.World.Schemas.Timezone

  @doc """
  Downcase timezone abbreviation
  """
  def downcase_abbreviation(%{abbreviation: abbreviation} = timezone) do
    Map.put(timezone, :abbreviation, String.downcase(abbreviation))
  end

  @doc """
  Validate data before inserting.
  """
  def changeset(%Timezone{} = changeset, attrs) do
    changeset
    |> cast(attrs, ~w(zone_id abbreviation time_start gmt_offset dst))
    |> validate_required([:zone_id, :abbreviation, :time_start, :gmt_offset, :dst])
    |> foreign_key_constraint(:zone_id, message: "does not exist")
  end
end
