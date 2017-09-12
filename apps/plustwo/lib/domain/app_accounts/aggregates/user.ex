defmodule Plustwo.Domain.AppAccounts.Aggregates.User do
  @moduledoc "A user on Plustwo."

  defstruct user_uuid: nil,
            app_account_uuid: nil,
            is_employee: nil,
            is_contributor: nil,
            family_name: nil,
            given_name: nil,
            middle_name: nil,
            birthdate_day: nil,
            birthdate_month: nil,
            birthdate_year: nil
  alias Plustwo.Domain.AppAccounts.Aggregates.User
  alias Plustwo.Domain.AppAccounts.Events.{UserBirthdateUpdated,
                                           UserCreated,
                                           UserMarkedAsContributor,
                                           UserMarkedAsEmployee,
                                           UserMarkedAsNonContributor,
                                           UserMarkedAsNonEmployee,
                                           UserNameUpdated}

  def apply(%User{} = user,
            %UserBirthdateUpdated{birthdate_day: birthdate_day,
                                  birthdate_month: birthdate_month,
                                  birthdate_year: birthdate_year}) do
    %User{user |
          birthdate_day: birthdate_day,
          birthdate_month: birthdate_month,
          birthdate_year: birthdate_year}
  end

  def apply(%User{} = user,
            %UserCreated{user_uuid: user_uuid,
                         app_account_uuid: app_account_uuid}) do
    %User{user | user_uuid: user_uuid, app_account_uuid: app_account_uuid}
  end

  def apply(%User{} = user, %UserMarkedAsContributor{}) do
    %User{user | is_contributor: true}
  end

  def apply(%User{} = user, %UserMarkedAsEmployee{}) do
    %User{user | is_employee: true}
  end

  def apply(%User{} = user, %UserMarkedAsNonContributor{}) do
    %User{user | is_contributor: false}
  end

  def apply(%User{} = user, %UserMarkedAsNonEmployee{}) do
    %User{user | is_employee: false}
  end

  def apply(%User{} = user,
            %UserNameUpdated{family_name: family_name,
                             given_name: given_name,
                             middle_name: middle_name}) do
    %User{user |
          family_name: family_name,
          given_name: given_name,
          middle_name: middle_name}
  end
end
