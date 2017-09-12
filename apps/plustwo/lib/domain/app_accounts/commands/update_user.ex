defmodule Plustwo.Domain.AppAccounts.Commands.UpdateUser do
  @moduledoc false

  defstruct user_uuid: nil,
            is_employee: nil,
            is_contributor: nil,
            given_name: nil,
            middle_name: nil,
            family_name: nil,
            birthdate_year: nil,
            birthdate_month: nil,
            birthdate_day: nil
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppAccounts.Commands.UpdateUser
  alias Plustwo.Domain.AppAccounts.Validators.{WithinRangeBirthdateYear,
                                               WithinRangeBirthdateDay}

  validates :user_uuid, presence: true, uuid: true
  validates :is_employee, boolean: true
  validates :is_contributor, boolean: true
  validates :given_name, string: true
  validates :middle_name, string: true
  validates :family_name, string: true
  validates :birthdate_year,
            integer: true,
            by: [
              function: &WithinRangeBirthdateYear.validate/2,
              allow_nil: true,
              allow_blank: true,
            ]
  validates :birthdate_month,
            integer: true,
            inclusion: [in: 1..12, allow_nil: true, allow_blank: true]
  validates :birthdate_day,
            integer: true,
            by: [
              function: &WithinRangeBirthdateDay.validate/2,
              allow_nil: true,
              allow_blank: true,
            ]

  @doc "Assigns user UUID."
  def assign_user_uuid(%UpdateUser{} = user, user_uuid) do
    %UpdateUser{user | user_uuid: user_uuid}
  end
end
