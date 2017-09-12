defmodule Plustwo.Storage do
  @moduledoc false

  alias EventStore.Storage.Initializer

  @doc "Clear the event store and read store databases."
  def reset! do
    :ok = Application.stop(:plustwo)
    :ok = Application.stop(:commanded)
    :ok = Application.stop(:eventstore)
    reset_event_store()
    reset_read_store()
    {:ok, _} = Application.ensure_all_started(:plustwo)
  end


  defp reset_event_store do
    event_store_config = Application.get_env(:eventstore, EventStore.Storage)
    {:ok, conn} = Postgrex.start_link(event_store_config)
    Initializer.reset! conn
  end


  defp reset_read_store do
    read_store_config =
      Application.get_env(:plustwo, Plustwo.Infrastructure.Repo.Postgres)
    {:ok, conn} = Postgrex.start_link(read_store_config)
    Postgrex.query! conn, truncate_read_store_tables(), []
  end


  defp truncate_read_store_tables do
    """
    TRUNCATE TABLE
      app_account,
      app_account_email,
      business,
      email_verification,
      plustwo_user,
      world_country,
      world_currency,
      world_locale,
      world_timezone,
      world_zone,
      projection_versions
    RESTART IDENTITY;
    """
  end
end
