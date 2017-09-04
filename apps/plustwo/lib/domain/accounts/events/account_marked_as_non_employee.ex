defmodule Plustwo.Domain.Accounts.Events.AccountMarkedAsNonEmployee do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_employee,
  ]
end
