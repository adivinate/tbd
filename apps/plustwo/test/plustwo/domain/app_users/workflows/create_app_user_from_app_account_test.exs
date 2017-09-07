defmodule Plustwo.Domain.AppUsers.Workflows.CreateAppUserFromAppAccountTest do
  @moduledoc false

  use Plustwo.DataCase

  import Commanded.Assertions.EventAssertions

  alias Plustwo.Domain.AppAccounts
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount
  alias Plustwo.Domain.AppUsers.Events.AppUserCreated

  describe "an app user" do
    @tag :integration
    test "should be created when a new user account is registered" do
      assert {:ok, %AppAccount{} = app_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  primary_email: "meow@gmail.com",
                                                })
      assert_receive_event AppUserCreated,
                           fn event ->
                             assert(event.app_account_uuid == app_account.uuid)
                           end
    end
  end
end
