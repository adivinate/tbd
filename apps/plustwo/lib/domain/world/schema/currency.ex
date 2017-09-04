defmodule Plustwo.Domain.World.Schemas.Currency do
  @moduledoc """
  Schema for currency. This list is obtained
  from Stripe. For more information,
  checkout https://gist.github.com/sammkj/abeea7806f7f6b2ab65218c234cb69f4

  ## Sample data

  Fields: "currency_name", "currency_code"

  {
    Afghan Afghani,AFN
    Albanian Lek,ALL
    Algerian Dinar,DZD
    Angolan Kwanza,AOA
    Argentine Peso,ARS
    Armenian Dram,AMD
    ...
  }

  """

  use Plustwo.Domain, :schema

  schema "world_currency" do
    field :code, :string
    field :name, :string

    timestamps()
  end
end
