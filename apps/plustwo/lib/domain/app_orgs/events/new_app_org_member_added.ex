defmodule Plustwo.Domain.AppOrgs.Events.NewAppOrgMemberAdded do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_org_uuid, :new_member_app_account_uuid]
end
