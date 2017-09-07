defmodule Plustwo.Domain.AppAccounts.Events.AppAccountSuspensionLifted do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid, :is_suspended]
end
