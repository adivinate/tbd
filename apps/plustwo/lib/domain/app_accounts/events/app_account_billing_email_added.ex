defmodule Plustwo.Domain.AppAccounts.Events.AppAccountBillingEmailAdded do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :billing_email]
end
