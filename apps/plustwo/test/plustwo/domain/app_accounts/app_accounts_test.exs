defmodule Plustwo.Domain.AppAccounts.AppAccountsTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppAccounts
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  describe "register an app account" do
    @tag :integration
    test "should succeed with valid user account data" do
      assert {:ok, %AppAccount{} = app_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  email: "meow@gmail.com",
                                                })
      assert app_account.handle_name == "meow"
      assert app_account.is_activated == true
      assert app_account.is_suspended == false
      assert app_account.is_employee == false
      assert app_account.is_contributor == false
      assert app_account.is_org == false
    end
    @tag :integration
    test "should succeed with valid organization account data" do
      assert {:ok, %AppAccount{} = user_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  email: "meow@gmail.com",
                                                })
      assert {:ok, %AppAccount{} = org_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: true,
                                                  handle_name: "meow_org",
                                                  email: "meow@meow.com",
                                                  org_owner_app_account_uuid: user_account.uuid,
                                                })
      assert org_account.handle_name == "meow_org"
      assert org_account.is_activated == false
      assert org_account.is_suspended == false
      assert org_account.is_employee == false
      assert org_account.is_contributor == false
      assert org_account.is_org == true
    end
    @tag :integration
    test "should be able to retrieve an app account using its UUID" do
      assert {:ok, %AppAccount{} = registered} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  email: "meow@gmail.com",
                                                })
      assert retrieved = AppAccounts.get_app_account_by_uuid(registered.uuid)
      assert registered.uuid == retrieved.uuid
      assert retrieved.handle_name == "meow"
    end
    @tag :integration
    test "should be able to retrieve an app account using its handle_name" do
      assert {:ok, %AppAccount{} = registered} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  email: "meow@gmail.com",
                                                })
      assert retrieved = AppAccounts.get_app_account_by_handle_name("meow")
      assert registered.uuid == retrieved.uuid
    end
    @tag :integration
    test "should be able to retrieve a user app account using primary email" do
      assert {:ok, %AppAccount{} = registered} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  email: "meow@gmail.com",
                                                })
      assert retrieved =
               AppAccounts.get_user_app_account_by_primary_email("meow@gmail.com")
      assert registered.uuid == retrieved.uuid
    end
  end
end
