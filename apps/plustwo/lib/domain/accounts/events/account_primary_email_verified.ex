defmodule Plustwo.Domain.Accounts.Events.AccountPrimaryEmailVerified do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_primary_email_verified,
  ]
end
