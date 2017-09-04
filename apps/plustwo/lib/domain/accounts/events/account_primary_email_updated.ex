defmodule Plustwo.Domain.Accounts.Events.AccountPrimaryEmailUpdated do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :primary_email,
    :is_primary_email_verified,
  ]
end
