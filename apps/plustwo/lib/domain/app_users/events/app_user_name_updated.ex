defmodule Plustwo.Domain.AppUsers.Events.AppUserNameUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_user_uuid, :given_name, :middle_name, :family_name]
end
