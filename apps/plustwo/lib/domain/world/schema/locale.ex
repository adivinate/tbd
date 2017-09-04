defmodule Plustwo.Domain.World.Schemas.Locale do
  @moduledoc """
  Schema for locales. This is a downloaded
  database from https://gist.github.com/sammkj/e6e4f86a734a7359438d0c2b4cf93153

  ## Sample data

  Fields: "locale_code", "locale_name"

  {
    af,"Afrikaans"
    af-NA,"Afrikaans (Namibia)"
    af-ZA,"Afrikaans (South Africa)"
    agq,"Aghem"
    agq-CM,"Aghem (Cameroon)"
    ak,"Akan"
    ...
  }

  """

  use Plustwo.Domain, :schema

  schema "world_locale" do
    field :code, :string
    field :name, :string

    timestamps()
  end
end
