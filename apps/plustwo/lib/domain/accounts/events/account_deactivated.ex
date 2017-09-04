defmodule Plustwo.Domain.Accounts.Events.AccountDeactivated do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_activated,
  ]
end
