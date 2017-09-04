defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateWorldZone do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:world_zone) do
      add :country_id, references(:world_country)
      add :name, :string
    end
    create unique_index(:world_zone, [:name], name: :zone_name)
  end
end
