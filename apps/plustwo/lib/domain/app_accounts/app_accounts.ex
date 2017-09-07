defmodule Plustwo.Domain.AppAccounts do
  @moduledoc "A central app account for user / organization on Plustwo."

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppAccounts.Notifications
  alias Plustwo.Domain.AppAccounts.Queries.{AppAccountQuery,
                                            AppAccountEmailQuery}
  alias Plustwo.Domain.AppAccounts.Schemas.{AppAccount, AppAccountEmail}
  alias Plustwo.Domain.AppAccounts.Commands.{RegisterAppAccount,
                                             UpdateAppAccount}

  @doc "Registers an app account for a user or an organization."
  def register_app_account(attrs \\ %{}) do
    app_account_uuid = UUID.uuid4()
    command =
      attrs
      |> RegisterAppAccount.new()
      |> RegisterAppAccount.assign_app_account_uuid(app_account_uuid)
      |> RegisterAppAccount.downcase_handle_name()
      |> RegisterAppAccount.downcase_primary_email()
      |> RegisterAppAccount.downcase_billing_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppAccount, app_account_uuid, version
    else
      reply ->
        reply
    end
  end


  @doc "Updates an app account."
  def update_app_account(%AppAccount{uuid: app_account_uuid},
                         %{primary_email: primary_email} = attrs) do
    command =
      attrs
      |> UpdateAppAccount.new()
      |> UpdateAppAccount.assign_app_account_uuid(app_account_uuid)
      |> UpdateAppAccount.downcase_primary_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppAccountEmail,
                             app_account_uuid,
                             primary_email,
                             0,
                             version
    else
      reply ->
        reply
    end
  end

  def update_app_account(%AppAccount{uuid: app_account_uuid}, attrs) do
    command =
      attrs
      |> UpdateAppAccount.new()
      |> UpdateAppAccount.assign_app_account_uuid(app_account_uuid)
      |> UpdateAppAccount.downcase_handle_name()
      |> UpdateAppAccount.downcase_new_billing_email()
      |> UpdateAppAccount.downcase_remove_billing_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppAccount, app_account_uuid, version
    else
      reply ->
        reply
    end
  end


  @doc "Retrieves an app account by UUID, or return `nil` if not found."
  def get_app_account_by_uuid(app_account_uuid) do
    app_account_uuid
    |> AppAccountQuery.by_uuid()
    |> Postgres.one()
  end


  @doc "Retrieves an app account by handle name, or return `nil` if not found."
  def get_app_account_by_handle_name(handle_name) do
    handle_name
    |> String.downcase()
    |> AppAccountQuery.by_handle_name()
    |> Postgres.one()
  end


  @doc "Retrieves a user account by primary_email, or return `nil` if not found."
  def get_user_app_account_by_primary_email(primary_email) do
    case primary_email
         |> String.downcase()
         |> AppAccountEmailQuery.by_address(0)
         |> Postgres.one() do
      nil ->
        nil

      %{app_account_uuid: app_account_uuid} ->
        get_app_account_by_uuid app_account_uuid
    end
  end
end
