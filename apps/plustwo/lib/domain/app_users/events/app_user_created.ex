defmodule Plustwo.Domain.AppUsers.Events.AppUserCreated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :app_account_uuid]
end
