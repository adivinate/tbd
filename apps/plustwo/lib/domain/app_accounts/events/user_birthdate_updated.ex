defmodule Plustwo.Domain.AppAccounts.Events.UserBirthdateUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:user_uuid, :birthdate_day, :birthdate_month, :birthdate_year]
end
