defmodule Plustwo.Domain.Accounts.Events.AccountBillingEmailAdded do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :billing_email,
  ]
end
