defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateWorldLocale do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:world_locale) do
      add :code, :string
      add :name, :string
    end
    create unique_index(:world_locale, [:code], name: :locale_code)
  end
end
