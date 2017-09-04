defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateWorldTimezone do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:world_timezone) do
      add :zone_id, references(:world_zone)
      add :abbreviation, :string
      add :time_start, :string
      add :gmt_offset, :string
      add :dst, :string
    end
    create index(:world_timezone, [:zone_id])
    create index(:world_timezone, [:time_start])
  end
end
