defmodule Plustwo.Domain.AppUsers.Events.AppUserCreated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_user_uuid, :app_account_uuid]
end
