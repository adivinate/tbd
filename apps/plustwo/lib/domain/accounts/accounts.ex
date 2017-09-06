defmodule Plustwo.Domain.Accounts do
  @moduledoc "This is a central account for user / organization. Each of them will have an account."

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.Accounts.Notifications
  alias Plustwo.Domain.Accounts.Queries.{AccountQuery, AccountEmailQuery}
  alias Plustwo.Domain.Accounts.Schemas.{Account, AccountEmail}
  alias Plustwo.Domain.Accounts.Commands.{RegisterAccount, UpdateAccount}

  @doc "Registers an account for a user or an organization."
  def register_account(attrs \\ %{}) do
    account_uuid = UUID.uuid4()
    command =
      attrs
      |> RegisterAccount.new()
      |> RegisterAccount.assign_uuid(account_uuid)
      |> RegisterAccount.downcase_handle_name()
      |> RegisterAccount.downcase_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for Account, account_uuid, version
    else
      reply ->
        reply
    end
  end


  @doc "Updates an account."
  def update_account(%Account{uuid: account_uuid},
                     %{primary_email: primary_email} = attrs) do
    command =
      attrs
      |> UpdateAccount.new()
      |> UpdateAccount.assign_uuid(account_uuid)
      |> UpdateAccount.downcase_primary_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AccountEmail,
                             account_uuid,
                             primary_email,
                             0,
                             version
    else
      reply ->
        reply
    end
  end

  def update_account(%Account{uuid: account_uuid}, attrs) do
    command =
      attrs
      |> UpdateAccount.new()
      |> UpdateAccount.assign_uuid(account_uuid)
      |> UpdateAccount.downcase_handle_name()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for Account, account_uuid, version
    else
      reply ->
        reply
    end
  end


  @doc "Retrieves an account by UUID, or return `nil` if not found."
  def get_account_by_uuid(account_uuid) do
    account_uuid
    |> AccountQuery.by_uuid()
    |> Postgres.one()
  end


  @doc "Retrieves an account by handle name, or return `nil` if not found."
  def get_account_by_handle_name(handle_name) when is_binary(handle_name) do
    handle_name
    |> String.downcase()
    |> AccountQuery.by_handle_name()
    |> Postgres.one()
  end

  @doc "Retrieves a user account by primary_email, or return `nil` if not found."
  def get_user_account_by_primary_email(primary_email)
      when is_binary(primary_email) do
    case primary_email
         |> String.downcase()
         |> AccountEmailQuery.by_address(0)
         |> Postgres.one() do
      nil ->
        nil

      %{account_uuid: account_uuid} ->
        get_account_by_uuid account_uuid
    end
  end
end
