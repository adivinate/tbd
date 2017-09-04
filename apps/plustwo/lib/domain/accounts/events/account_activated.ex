defmodule Plustwo.Domain.Accounts.Events.AccountActivated do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_activated,
  ]
end
