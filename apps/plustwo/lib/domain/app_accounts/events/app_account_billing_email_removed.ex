defmodule Plustwo.Domain.AppAccounts.Events.AppAccountBillingEmailRemoved do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :billing_email]
end
