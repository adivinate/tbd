defmodule Plustwo.Domain.AppAccounts.CommandHandlers.UserHandler do
  @moduledoc false

  @behaviour Commanded.Commands.Handler
  alias Plustwo.Domain.AppAccounts.Aggregates.User
  alias Plustwo.Domain.AppAccounts.Commands.{CreateUser, UpdateUser}
  alias Plustwo.Domain.AppAccounts.Events.{UserBirthdateUpdated,
                                           UserCreated,
                                           UserMarkedAsContributor,
                                           UserMarkedAsEmployee,
                                           UserMarkedAsNonContributor,
                                           UserMarkedAsNonEmployee,
                                           UserNameUpdated}

  @doc "Create a user."
  def handle(%User{user_uuid: nil},
             %CreateUser{user_uuid: user_uuid,
                         app_account_uuid: app_account_uuid}) do
    %UserCreated{user_uuid: user_uuid, app_account_uuid: app_account_uuid}
  end

  @doc "Update a user's name, birthdate, etc.."
  def handle(%User{} = user, %UpdateUser{} = update) do
    fns = [
      &birthdate_updated/2,
      &name_updated/2,
      &employee_status_updated/2,
      &contributor_status_updated/2,
    ]
    Enum.reduce fns, [], fn change, events -> case change.(user, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end end
  end


  defp birthdate_updated(%User{},
                         %UpdateUser{birthdate_day: nil,
                                     birthdate_month: nil,
                                     birthdate_year: nil}) do
    nil
  end

  defp birthdate_updated(%User{},
                         %UpdateUser{birthdate_day: "",
                                     birthdate_month: "",
                                     birthdate_year: ""}) do
    nil
  end

  defp birthdate_updated(%User{birthdate_day: birthdate_day,
                               birthdate_month: birthdate_month,
                               birthdate_year: birthdate_year},
                         %UpdateUser{birthdate_day: birthdate_day,
                                     birthdate_month: birthdate_month,
                                     birthdate_year: birthdate_year}) do
    nil
  end

  defp birthdate_updated(%User{user_uuid: user_uuid},
                         %UpdateUser{birthdate_day: birthdate_day,
                                     birthdate_month: birthdate_month,
                                     birthdate_year: birthdate_year}) do
    %UserBirthdateUpdated{user_uuid: user_uuid,
                          birthdate_day: birthdate_day,
                          birthdate_month: birthdate_month,
                          birthdate_year: birthdate_year}
  end


  defp name_updated(%User{},
                    %UpdateUser{given_name: nil,
                                middle_name: nil,
                                family_name: nil}) do
    nil
  end

  defp name_updated(%User{},
                    %UpdateUser{given_name: "",
                                middle_name: "",
                                family_name: ""}) do
    nil
  end

  defp name_updated(%User{given_name: given_name,
                          middle_name: middle_name,
                          family_name: family_name},
                    %UpdateUser{given_name: given_name,
                                middle_name: middle_name,
                                family_name: family_name}) do
    nil
  end

  defp name_updated(%User{user_uuid: user_uuid},
                    %UpdateUser{given_name: given_name,
                                middle_name: middle_name,
                                family_name: family_name}) do
    %UserNameUpdated{user_uuid: user_uuid,
                     given_name: given_name,
                     middle_name: middle_name,
                     family_name: family_name}
  end


  defp employee_status_updated(%User{}, %UpdateUser{is_employee: nil}) do
    nil
  end

  defp employee_status_updated(%User{}, %UpdateUser{is_employee: ""}) do
    nil
  end

  defp employee_status_updated(%User{is_employee: is_employee},
                               %UpdateUser{is_employee: is_employee}) do
    nil
  end

  defp employee_status_updated(%User{user_uuid: user_uuid},
                               %UpdateUser{is_employee: true}) do
    %UserMarkedAsEmployee{user_uuid: user_uuid}
  end

  defp employee_status_updated(%User{user_uuid: user_uuid},
                               %UpdateUser{is_employee: false}) do
    %UserMarkedAsNonEmployee{user_uuid: user_uuid}
  end


  defp contributor_status_updated(%User{}, %UpdateUser{is_contributor: nil}) do
    nil
  end

  defp contributor_status_updated(%User{}, %UpdateUser{is_contributor: ""}) do
    nil
  end

  defp contributor_status_updated(%User{is_contributor: is_contributor},
                                  %UpdateUser{is_contributor: is_contributor}) do
    nil
  end

  defp contributor_status_updated(%User{user_uuid: user_uuid},
                                  %UpdateUser{is_contributor: true}) do
    %UserMarkedAsContributor{user_uuid: user_uuid}
  end

  defp contributor_status_updated(%User{user_uuid: user_uuid},
                                  %UpdateUser{is_contributor: false}) do
    %UserMarkedAsNonContributor{user_uuid: user_uuid}
  end
end
