defmodule Plustwo.Domain.AppAccounts.Notifications do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.AppAccounts.Schemas.{AppAccount, AppAccountEmail}
  alias Plustwo.Domain.AppAccounts.Queries.{AppAccountQuery,
                                            AppAccountEmailQuery}

  @doc "Waits until the given read model is updated to the given version."
  def wait_for(AppAccount, app_account_uuid, version) do
    case Postgres.one(AppAccountQuery.by_uuid(app_account_uuid, version)) do
      nil ->
        subscribe_and_wait AppAccount, app_account_uuid, version

      projection ->
        {:ok, projection}
    end
  end

  def wait_for(AppAccountEmail,
               app_account_uuid,
               email_address,
               email_type,
               version) do
    case Postgres.one(AppAccountEmailQuery.by_app_account_uuid(app_account_uuid,
                                                               email_address,
                                                               email_type,
                                                               version)) do
      nil ->
        subscribe_and_wait AppAccountEmail,
                           app_account_uuid,
                           email_address,
                           email_type,
                           version

      projection ->
        {:ok, projection}
    end
  end


  @doc "Publishes updated account read model to interested subscribers."
  def publish_changes(%{app_account: %AppAccount{} = app_account}) do
    publish app_account
  end


  def publish_changes(%{app_account: {_, app_accounts}})
      when is_list(app_accounts) do
    Enum.each app_accounts, &publish/1
  end


  def publish_changes(%{
                        app_account_email: %AppAccountEmail{} =
                          app_account_email,
                      }) do
    publish app_account_email
  end


  def publish_changes(%{app_account_email: {_, app_account_emails}})
      when is_list(app_account_emails) do
    Enum.each app_account_emails, &publish/1
  end


  defp publish(%AppAccount{uuid: app_account_uuid, version: version} = app_account) do
    Registry.dispatch Plustwo.Domain.AppAccounts,
                      {AppAccount, app_account_uuid, version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {AppAccount, app_account}
                        end
                      end
  end

  defp publish(%AppAccountEmail{app_account_uuid: app_account_uuid,
                                address: email_address,
                                type: email_type,
                                version: version} =
                 app_account_email) do
    Registry.dispatch Plustwo.Domain.AppAccounts,
                      {AppAccountEmail,
                       app_account_uuid,
                       email_address,
                       email_type,
                       version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {AppAccountEmail, app_account_email}
                        end
                      end
  end


  defp subscribe_and_wait(AppAccount, app_account_uuid, version) do
    Registry.register Plustwo.Domain.AppAccounts,
                      {AppAccount, app_account_uuid, version},
                      []
    receive do
      {AppAccount, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end

  defp subscribe_and_wait(AppAccountEmail,
                          app_account_uuid,
                          email_address,
                          email_type,
                          version) do
    Registry.register Plustwo.Domain.AppAccounts,
                      {AppAccountEmail,
                       app_account_uuid,
                       email_address,
                       email_type,
                       version},
                      []
    receive do
      {AppAccountEmail, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end
end
