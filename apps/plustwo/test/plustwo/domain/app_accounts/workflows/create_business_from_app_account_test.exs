defmodule Plustwo.Domain.AppAccounts.Workflows.CreateBusinessFromAppAccountTest do
  @moduledoc false

  use Plustwo.DataCase

  import Commanded.Assertions.EventAssertions

  alias Plustwo.Domain.AppAccounts.Events.BusinessCreated

  describe "a business" do
    setup [:create_business_app_account]
    @tag :integration
    test "should be created when a new business app account is registered",
         %{business_app_account: business_app_account} do
      assert_receive_event BusinessCreated,
                           fn event ->
                             assert(event.app_account_uuid ==
                                      business_app_account.uuid)
                           end
    end
  end
end
