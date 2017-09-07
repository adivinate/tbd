defmodule Plustwo.Domain.AppAccounts.Events.AppAccountPrimaryEmailVerified do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid, :is_verified]
end
