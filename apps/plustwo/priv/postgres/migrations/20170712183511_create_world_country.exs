defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateWorldCountry do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:world_country) do
      add :code, :string
      add :name, :string
      add :lname, :string
    end
    create index(:world_country, [:lname])
    create unique_index(:world_country, [:code], name: :country_code)
  end
end
