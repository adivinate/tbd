defmodule Plustwo.Domain.AppAccounts.Workflows.CreateUserFromAppAccountTest do
  @moduledoc false

  use Plustwo.DataCase

  import Commanded.Assertions.EventAssertions

  alias Plustwo.Domain.AppAccounts.Events.UserCreated

  describe "a user" do
    setup [:create_user_app_account]
    @tag :integration
    test "should be created when a new user app account is registered",
         %{user_app_account: user_app_account} do
      assert_receive_event UserCreated,
                           fn event ->
                             assert(event.app_account_uuid ==
                                      user_app_account.uuid)
                           end
    end
  end
end
