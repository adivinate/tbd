defmodule Plustwo.Domain.AppOrgs.Events.AppOrgBusinessInfoUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_org_uuid, :name, :start_date, :mission, :description]
end
