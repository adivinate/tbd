defmodule Plustwo.Domain.AppUsers.Events.AppUserBirthdateUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :birthdate_day, :birthdate_month, :birthdate_year]
end
