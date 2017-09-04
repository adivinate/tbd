defmodule Plustwo.Domain.Accounts do
  @moduledoc "This is a central account for user / organization. Each of them\nwill have an account.\n"

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.Accounts.Notifications
  alias Plustwo.Domain.Accounts.Queries.AccountQuery
  alias Plustwo.Domain.Accounts.Schemas.{Account, AccountEmail}
  alias Plustwo.Domain.Accounts.Commands.{RegisterAccount, UpdateAccount}

  ##########
  # Mutations
  ##########
  @doc "Register an account for a user or an organization."
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


  @doc """
  Updates an account.

  ## Function Arguments

  Different kinds of updates require different sets of function arguments.

    1. Update account activation status
      - is_activated
    2. Update account suspension status
      - is_suspended
    3. Update account employee status
      - is_employee
    4. Update account handle name
      - handle_name
    5. Update account primary email
      - primary_email
    6. Verify account primary email
      - primary_email_verification_code
    7. Add new billing email
      - new_billing_email
    8. Remove an existing billing email
    - remove_billing_email

  """
  def update_account(%Account{uuid: account_uuid}, attrs \\ %{}) do
    command =
      attrs
      |> UpdateAccount.new()
      |> UpdateAccount.assign_account_uuid(account_uuid)
      |> UpdateAccount.downcase_handle_name()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for Account, account_uuid, version
    else
      reply ->
        reply
    end
  end


  ##########
  # Queries
  ##########
  @doc "Retrieves an account by UUID, or return `nil` if not found."
  def get_account_by_uuid(uuid) do
    uuid
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
end
