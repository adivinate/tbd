defmodule Plustwo.Domain.Accounts.Events.AccountMarkedAsEmployee do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_employee,
  ]
end
