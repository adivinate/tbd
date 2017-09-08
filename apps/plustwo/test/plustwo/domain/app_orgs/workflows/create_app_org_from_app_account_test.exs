defmodule Plustwo.Domain.AppOrgs.Workflows.CreateAppOrgFromAppAccountTest do
  @moduledoc false

  use Plustwo.DataCase

  import Commanded.Assertions.EventAssertions

  alias Plustwo.Domain.AppOrgs.Events.AppOrgCreated

  describe "an app org" do
    setup [:create_org_app_account]
    @tag :integration
    test "should be created when a new organization app account is registered", %{org_app_account: org_app_account} do
      assert_receive_event AppOrgCreated,
                           fn event ->
                             assert(event.app_account_uuid == org_app_account.uuid)
                           end
    end
  end
end
