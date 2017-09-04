defmodule Plustwo.Domain.World.Schemas.Country do
  @moduledoc """
  Schema for countries. This is a downloaded
  database from TimezoneDB. For more information,
  checkout https://timezonedb.com/download

  ## Sample data

  Fields: "country_code", "country_name"

  {
    "AD","Andorra"
    "AE","United Arab Emirates"
    "AF","Afghanistan"
    "AG","Antigua and Barbuda"
    ...
  }

  """

  use Plustwo.Domain, :schema

  schema "world_country" do
    field :code, :string
    field :name, :string
    field :lname, :string

    timestamps()
  end
end
