defmodule Plustwo.Domain.AppOrgs.Events.AppOrgContactInfoUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_org_uuid, :website_url, :phone_number, :email_address]
end
