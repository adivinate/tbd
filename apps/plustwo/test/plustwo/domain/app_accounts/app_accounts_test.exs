defmodule Plustwo.Domain.AppAccounts.AppAccountsTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppAccounts
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  describe "app account registration" do
    @tag :integration
    test "should succeed with valid user app account data" do
      assert {:ok, %AppAccount{} = user_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  primary_email: "meow@gmail.com",
                                                })
      assert user_account.handle_name == "meow"
      assert user_account.is_activated == true
      assert user_account.is_suspended == false
      assert user_account.is_employee == false
      assert user_account.is_contributor == false
      assert user_account.is_org == false
    end
    @tag :integration
    test "should succeed with valid organization app account data" do
      assert {:ok, %AppAccount{} = org_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: true,
                                                  handle_name: "meow_org",
                                                  billing_email: "meow@meow.com",
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
                                                  primary_email: "meow@gmail.com",
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
                                                  primary_email: "meow@gmail.com",
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
                                                  primary_email: "meow@gmail.com",
                                                })
      assert retrieved =
               AppAccounts.get_user_app_account_by_primary_email("meow@gmail.com")
      assert registered.uuid == retrieved.uuid
    end
    @tag :integration
    test "should not allow user account registration when the same handle name and primary email address already exist" do
      assert {:ok, _} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  primary_email: "meow@gmail.com",
                                                })
      assert {:error,
                %{
                  primary_email: ["has already been taken"],
                  handle_name: ["has already been taken"],
                }} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  primary_email: "meow@gmail.com",
                                                })
    end
  end
  describe "update an app account" do
    test "should not allow organization account to be tagged as contributor" do
      assert {:ok, %AppAccount{} = org_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: true,
                                                  handle_name: "meow_org",
                                                  billing_email: "meow@meow.com",
                                                })
      assert {:error,
                %{app_account: ["organization cannot be a contributor"]}} =
               AppAccounts.update_app_account(org_account,
                                              %{is_contributor: true})
    end
    test "should not allow organization account to be tagged as employee" do
      assert {:ok, %AppAccount{} = org_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: true,
                                                  handle_name: "meow_org",
                                                  billing_email: "meow@meow.com",
                                                })
      assert {:error, %{app_account: ["organization cannot be an employee"]}} =
               AppAccounts.update_app_account(org_account, %{is_employee: true})
    end
    test "should not allow user account to have billing email" do
      assert {:ok, %AppAccount{} = user_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  primary_email: "meow@gmail.com",
                                                })
      assert {:error,
                %{app_account: ["user account does not have billing email"]}} =
               AppAccounts.update_app_account(user_account,
                                              %{
                                                new_billing_email: "fake@gmail.com",
                                              })
    end
    test "should not allow organization account to have primary email" do
      assert {:ok, %AppAccount{} = org_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: true,
                                                  handle_name: "meow_org",
                                                  billing_email: "meow@meow.com",
                                                })
      assert {:error,
                %{
                  app_account: [
                    "organization account does not have primary email",
                  ],
                }} =
               AppAccounts.update_app_account(org_account,
                                              %{
                                                primary_email: "fake@gmail.com",
                                              })
    end
  end
end
