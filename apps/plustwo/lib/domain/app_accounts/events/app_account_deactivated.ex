defmodule Plustwo.Domain.AppAccounts.Events.AppAccountDeactivated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid, :is_activated]
end
