defmodule Plustwo.Domain.Accounts.Events.AccountBillingEmailRemoved do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :billing_email,
  ]
end
