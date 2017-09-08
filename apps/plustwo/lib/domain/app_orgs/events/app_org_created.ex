defmodule Plustwo.Domain.AppOrgs.Events.AppOrgCreated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_org_uuid, :app_account_uuid, :type]
end
