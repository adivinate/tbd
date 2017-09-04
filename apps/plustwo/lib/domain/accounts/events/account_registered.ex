defmodule Plustwo.Domain.Accounts.Events.AccountRegistered do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :is_activated,
    :is_suspended,
    :is_employee,
    :is_contributor,
    :is_org,
    :handle_name,
    :email,
    :email_type,
    :is_email_verified,
    :joined_at,
  ]
end
