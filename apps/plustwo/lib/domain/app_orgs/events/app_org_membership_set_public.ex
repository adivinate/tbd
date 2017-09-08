defmodule Plustwo.Domain.AppOrgs.Events.AppOrgMembershipSetPublic do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_org_uuid, :member_app_account_uuid]
end
