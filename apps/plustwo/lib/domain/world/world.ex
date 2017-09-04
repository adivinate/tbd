defmodule Plustwo.Domain.World do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.World.Schemas.{
    Country,
    Currency,
    Locale,
    Timezone,
    Zone,
  }
  alias Plustwo.Domain.World.Commands.{
    CreateCountry,
    CreateCurrency,
    CreateLocale,
    CreateTimezone,
    CreateZone,
  }

  ##########
  # Mutations
  ##########

  @doc "Create a country."
  def create_country(attrs \\ %{}) do
    attrs = attrs
    |> CreateCountry.downcase_code()
    |> CreateCountry.assign_lname()
    %Country{}
    |> CreateCountry.changeset(attrs)
    |> Postgres.insert()
  end

  @doc "Create a currency."
  def create_currency(attrs \\ %{}) do
    attrs = CreateCurrency.downcase_code(attrs)
    %Currency{}
    |> CreateCurrency.changeset(attrs)
    |> Postgres.insert()
  end

  @doc "Create a locale."
  def create_locale(attrs \\ %{}) do
    attrs = CreateLocale.downcase_code(attrs)
    %Locale{}
    |> CreateLocale.changeset(attrs)
    |> Postgres.insert()
  end

  @doc "Create a timezone."
  def create_timezone(attrs \\ %{}) do
    attrs = CreateTimezone.downcase_abbreviation(attrs)
    %Timezone{}
    |> CreateTimezone.changeset(attrs)
    |> Postgres.insert()
  end

  @doc "Create a zone."
  def create_zone(attrs \\ %{}) do
    %Zone{}
    |> CreateZone.changeset(attrs)
    |> Postgres.insert()
  end

  ##########
  # Queries
  ##########

  @doc "Get a country by country code, or return `nil` if not found."
  def get_country_by_code(code) when is_binary(code) do
    Postgres.get_by(Country, code: String.downcase(code))
  end

  @doc "Get a country by country ID, or return `nil` if not found."
  def get_country_by_id(id) do
    Postgres.get(Country, id)
  end

  @doc "Get a currency by currency code, or return `nil` if not found."
  def get_currency_by_code(code) when is_binary(code) do
    Postgres.get_by(Currency, code: String.downcase(code))
  end

  @doc "Get a currency by currencyID, or return `nil` if not found."
  def get_currency_by_id(id) do
    Postgres.get(Currency, id)
  end

  @doc "Get a locale by locale code, or return `nil` if not found."
  def get_locale_by_code(code) when is_binary(code) do
    Postgres.get_by(Locale, code: String.downcase(code))
  end

  @doc "Get a locale by locale ID, or return `nil` if not found."
  def get_locale_by_id(id) do
    Postgres.get(Locale, id)
  end

  @doc "Get a timezone by timezone ID, or return `nil` if not found."
  def get_timezone_by_id(id) do
    Postgres.get(Timezone, id)
  end

  @doc "Get a zone by zone name, or return `nil` if not found."
  def get_zone_by_name(name) when is_binary(name) do
    Postgres.get_by(Zone, name: name)
  end
end
