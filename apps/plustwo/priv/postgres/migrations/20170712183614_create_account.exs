defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAccount do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:plustwo_account, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :version, :integer, default: 0
      add :is_activated, :boolean
      add :is_suspended, :boolean
      add :is_employee, :boolean
      add :is_contributor, :boolean
      add :is_org, :boolean
      add :handle_name, :string
      add :joined_at, :datetime
    end
    create unique_index(:plustwo_account,
                        [:handle_name],
                        name: :account_handle_name)
  end
end