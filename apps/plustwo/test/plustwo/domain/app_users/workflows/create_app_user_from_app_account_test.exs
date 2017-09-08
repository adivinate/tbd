defmodule Plustwo.Domain.AppUsers.Workflows.CreateAppUserFromAppAccountTest do
  @moduledoc false

  use Plustwo.DataCase

  import Commanded.Assertions.EventAssertions

  alias Plustwo.Domain.AppUsers.Events.AppUserCreated

  describe "an app user" do
    setup [:create_user_app_account]
    @tag :integration
    test "should be created when a new user app account is registered",
         %{user_app_account: user_app_account} do
      assert_receive_event AppUserCreated,
                           fn event ->
                             assert(event.app_account_uuid ==
                                      user_app_account.uuid)
                           end
    end
  end
end
