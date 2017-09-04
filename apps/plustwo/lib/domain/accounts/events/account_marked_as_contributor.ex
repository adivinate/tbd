defmodule Plustwo.Domain.Accounts.Events.AccountMarkedAsContributor do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_contributor,
  ]
end
