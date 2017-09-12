defmodule Plustwo.Domain.AppAccounts do
  @moduledoc "A central app account for user / organization on Plustwo."

  alias Commanded.Assertions.EventAssertions
  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppAccounts.Notifications
  alias Plustwo.Domain.AppAccounts.Queries.{AppAccountQuery,
                                            AppAccountEmailQuery}
  alias Plustwo.Domain.AppAccounts.Schemas.{AppAccountEmail,
                                            AppAccount,
                                            Business,
                                            User}
  alias Plustwo.Domain.AppAccounts.Commands.{RegisterAppAccount,
                                             UpdateAppAccount,
                                             UpdateBusiness,
                                             UpdateUser}
  alias Plustwo.Domain.AppAccounts.Events.{BusinessCreated, UserCreated}

  @doc "Registers an app account for a user."
  def register_app_account(%{type: 0} = attrs) do
    app_account_uuid = UUID.uuid4()
    command =
      attrs
      |> RegisterAppAccount.new()
      |> RegisterAppAccount.assign_app_account_uuid(app_account_uuid)
      |> RegisterAppAccount.downcase_handle_name()
      |> RegisterAppAccount.downcase_primary_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      EventAssertions.wait_for_event UserCreated,
                                     fn event ->
                                       event.app_account_uuid ==
                                         app_account_uuid
                                     end
      case Notifications.wait_for(AppAccount, app_account_uuid, version) do
        {:ok, %AppAccount{} = app_account} ->
          preload app_account

        reply ->
          reply
      end
    else
      reply ->
        reply
    end
  end

  @doc "Register an app account for business."
  def register_app_account(%{type: 1} = attrs) do
    app_account_uuid = UUID.uuid4()
    command =
      attrs
      |> RegisterAppAccount.new()
      |> RegisterAppAccount.assign_app_account_uuid(app_account_uuid)
      |> RegisterAppAccount.downcase_handle_name()
      |> RegisterAppAccount.downcase_billing_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      EventAssertions.wait_for_event BusinessCreated,
                                     fn event ->
                                       event.app_account_uuid ==
                                         app_account_uuid
                                     end
      case Notifications.wait_for(AppAccount, app_account_uuid, version) do
        {:ok, %AppAccount{} = app_account} ->
          preload app_account

        reply ->
          reply
      end
    else
      reply ->
        reply
    end
  end


  @doc "Updates an app account."
  def update_app_account(%AppAccount{uuid: app_account_uuid, type: 0},
                         %{primary_email: _} = attrs) do
    command =
      attrs
      |> UpdateAppAccount.new()
      |> UpdateAppAccount.assign_app_account_uuid(app_account_uuid)
      |> UpdateAppAccount.downcase_primary_email()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      case Notifications.wait_for(AppAccountEmail,
                                  app_account_uuid,
                                  0,
                                  version) do
        {:ok, %AppAccount{} = app_account} ->
          preload app_account

        reply ->
          reply
      end
    else
      reply ->
        reply
    end
  end

  def update_app_account(%AppAccount{uuid: app_account_uuid, type: 0},
                         %{primary_email_verification_code: _} = attrs) do
    command =
      attrs
      |> UpdateAppAccount.new()
      |> UpdateAppAccount.assign_app_account_uuid(app_account_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      case Notifications.wait_for(AppAccountEmail,
                                  app_account_uuid,
                                  0,
                                  version) do
        {:ok, %AppAccount{} = app_account} ->
          preload app_account
      end
    else
      reply ->
        reply
    end
  end

  def update_app_account(%AppAccount{uuid: app_account_uuid, type: 0},
                         %{given_name: _, family_name: _, middle_name: _} =
                           attrs) do
    case get_user_by_app_account_uuid(app_account_uuid) do
      nil ->
        {:error, "unable to find user"}

      %User{uuid: user_uuid} ->
        command =
          attrs
          |> UpdateUser.new()
          |> UpdateUser.assign_user_uuid(user_uuid)
        with {:ok, version} <-
               Router.dispatch(command, include_aggregate_version: true) do
          case Notifications.wait_for(User, user_uuid, version) do
            {:ok, %AppAccount{} = app_account} ->
              preload app_account

            reply ->
              reply
          end
        else
          reply ->
            reply
        end
    end
  end

  def update_app_account(%AppAccount{uuid: app_account_uuid, type: 0},
                         %{
                             birthdate_year: _,
                             birthdate_month: _,
                             birthdate_day: _,
                           } =
                           attrs) do
    case get_user_by_app_account_uuid(app_account_uuid) do
      nil ->
        {:error, "unable to find user"}

      %User{uuid: user_uuid} ->
        command =
          attrs
          |> UpdateUser.new()
          |> UpdateUser.assign_user_uuid(user_uuid)
        with {:ok, version} <-
               Router.dispatch(command, include_aggregate_version: true) do
          case Notifications.wait_for(User, user_uuid, version) do
            {:ok, %AppAccount{} = app_account} ->
              preload app_account

            reply ->
              reply
          end
        else
          reply ->
            reply
        end
    end
  end

  def update_app_account(%AppAccount{uuid: app_account_uuid, type: 0},
                         %{given_name: _, family_name: _, middle_name: _} =
                           attrs) do
    case get_user_by_app_account_uuid(app_account_uuid) do
      nil ->
        {:error, "unable to find user"}

      %User{uuid: user_uuid} ->
        command =
          attrs
          |> UpdateUser.new()
          |> UpdateUser.assign_user_uuid(user_uuid)
        with {:ok, version} <-
               Router.dispatch(command, include_aggregate_version: true) do
          case Notifications.wait_for(User, user_uuid, version) do
            {:ok, %AppAccount{} = app_account} ->
              preload app_account

            reply ->
              reply
          end
        else
          reply ->
            reply
        end
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
    |> Postgres.preload(:emails)
  end


  @doc "Retrieves an app account by handle name, or return `nil` if not found."
  def get_app_account_by_handle_name(handle_name) do
    handle_name
    |> String.downcase()
    |> AppAccountQuery.by_handle_name()
    |> Postgres.one()
    |> Postgres.preload(:emails)
  end


  @doc "Retrieves a app account by primary_email, or return `nil` if not found."
  def get_app_account_by_primary_email(primary_email) do
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


  defp get_user_by_app_account_uuid(app_account_uuid) do
    Postgres.get_by User, app_account_uuid: app_account_uuid
  end


  defp get_business_by_app_account_uuid(app_account_uuid) do
    Postgres.get_by Business, app_account_uuid: app_account_uuid
  end


  defp preload(%AppAccount{type: 0} = app_account) do
    {:ok, app_account
     |> Postgres.preload(:emails)
     |> Postgres.preload(:user)}
  end

  defp preload(%AppAccount{type: 1} = app_account) do
    {:ok, app_account
     |> Postgres.preload(:emails)
     |> Postgres.preload(:business)}
  end
end
