defmodule Plustwo.Domain.AppAccounts.Events.BusinessContactInfoUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:business_uuid, :website_url, :phone_number, :email_address]
end
