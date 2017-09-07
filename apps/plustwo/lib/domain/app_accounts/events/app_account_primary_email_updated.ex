defmodule Plustwo.Domain.AppAccounts.Events.AppAccountPrimaryEmailUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid, :email_address, :is_verified]
end
