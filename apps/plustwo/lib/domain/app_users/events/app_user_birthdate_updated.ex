defmodule Plustwo.Domain.AppUsers.Events.AppUserBirthdateUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_user_uuid, :birthdate_day, :birthdate_month, :birthdate_year]
end
