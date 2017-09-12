defmodule Plustwo.Domain.AppAccounts.Events.AppAccountRegistered do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
              :app_account_uuid,
              :type,
              :is_activated,
              :is_suspended,
              :handle_name,
              :email_address,
              :email_type,
              :joined_at,
            ]
end
