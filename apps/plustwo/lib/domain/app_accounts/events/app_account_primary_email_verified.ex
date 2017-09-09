defmodule Plustwo.Domain.AppAccounts.Events.AppAccountPrimaryEmailVerified do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid]
end
