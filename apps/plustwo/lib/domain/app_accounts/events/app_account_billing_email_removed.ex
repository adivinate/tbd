defmodule Plustwo.Domain.AppAccounts.Events.AppAccountBillingEmailRemoved do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid, :email_address]
end
