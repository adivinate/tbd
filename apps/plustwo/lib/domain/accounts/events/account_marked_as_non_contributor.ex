defmodule Plustwo.Domain.Accounts.Events.AccountMarkedAsNonContributor do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_contributor,
  ]
end
