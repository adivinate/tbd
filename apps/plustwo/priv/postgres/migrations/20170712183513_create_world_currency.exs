defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateWorldCurrency do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:world_currency) do
      add :code, :string
      add :name, :string
    end
    create unique_index(:world_currency, [:code], name: :currency_code)
  end
end
