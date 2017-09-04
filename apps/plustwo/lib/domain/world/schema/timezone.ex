defmodule Plustwo.Domain.World.Schemas.Timezone do
  @moduledoc """
  Schema for timezones. This is a downloaded
  database from TimezoneDB. For more information,
  checkout https://timezonedb.com/download

  ## Sample data

  Fields: "zone_id", "abbreviation", "time_start", "gmt_offset", "dst"

  {
    "1","LMT","-2177453165","364","0"
    "1","WET","-2177453164","0","0"
    "1","CET","-733881600","3600","0"
    "1","CEST","481078800","7200","1"
    ...
  }

  """

  use Plustwo.Domain, :schema
  alias Plustwo.Domain.World.Schemas.Zone

  schema "world_timezone" do
    belongs_to :zone, Zone, foreign_key: :zone_id
    field :abbreviation, :string
    field :time_start, :string
    field :gmt_offset, :string
    field :dst, :string

    timestamps()
  end
end
