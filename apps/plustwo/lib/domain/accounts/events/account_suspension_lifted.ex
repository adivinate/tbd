defmodule Plustwo.Domain.Accounts.Events.AccountSuspensionLifted do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_suspended,
  ]
end
