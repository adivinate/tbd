defmodule Plustwo.Domain.Accounts do
  @moduledoc "This is a central account for user / organization. Each of them will have an account."

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.Accounts.Notifications
  alias Plustwo.Domain.Accounts.Queries.{AccountQuery, AccountEmailQuery}
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


  @doc "Updates an account.\n\n## Function Arguments\n\nDifferent kinds of updates require different sets of function arguments.\n\n  1. Update account activation status\n    - is_activated\n  2. Update account suspension status\n    - is_suspended\n  3. Update account employee status\n    - is_employee\n  4. Update account handle name\n    - handle_name\n  5. Update account primary email\n    - primary_email\n  6. Verify account primary email\n    - primary_email_verification_code\n  7. Add new billing email\n    - new_billing_email\n  8. Remove an existing billing email\n  - remove_billing_email\n\n"
  def update_account(%Account{uuid: account_uuid},
                     %{primary_email: primary_email} = attrs) do
    command =
      attrs
      |> UpdateAccount.new()
      |> UpdateAccount.assign_account_uuid(account_uuid)
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
    |> AccountQuery.by_uuid(:with_assoc)
    |> Postgres.one()
  end


  @doc "Retrieves an account by handle name, or return `nil` if not found."
  def get_account_by_handle_name(handle_name) when is_binary(handle_name) do
    handle_name
    |> String.downcase()
    |> AccountQuery.by_handle_name(:with_assoc)
    |> Postgres.one()
  end

  @doc "Retrieves a user account by primary_email, or return `nil` if not found."
  def get_user_account_by_primary_email(primary_email)
      when is_binary(primary_email) do
    case primary_email
         |> String.downcase()
         |> AccountEmailQuery.by_address(0, :with_assoc)
         |> Postgres.one() do
      nil ->
        nil

      %{account_uuid: account_uuid} ->
        get_account_by_uuid(account_uuid)
    end
  end
end
