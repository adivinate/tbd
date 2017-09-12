defmodule Plustwo.Domain.AppAccounts.Events.UserCreated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:user_uuid, :app_account_uuid]
end
