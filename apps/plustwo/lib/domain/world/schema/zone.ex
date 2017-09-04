defmodule Plustwo.Domain.World.Schemas.Zone do
  @moduledoc """
  Schema for zones. This is a downloaded
  database from TimezoneDB. For more information,
  checkout https://timezonedb.com/download

  ## Sample data

  Fields: "zone_id", "country_code", "zone_name"

  {
    "1","AD","Europe/Andorra"
    "2","AE","Asia/Dubai"
    "3","AF","Asia/Kabul"
    ...
  }

  """

  use Plustwo.Domain, :schema
  alias Plustwo.Domain.World.Schemas.Country

  schema "world_zone" do
    belongs_to :country, Country, foreign_key: :country_id
    field :name, :string

    timestamps()
  end
end
