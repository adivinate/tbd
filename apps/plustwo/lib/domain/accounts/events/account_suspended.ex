defmodule Plustwo.Domain.Accounts.Events.AccountSuspended do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_suspended,
  ]
end
