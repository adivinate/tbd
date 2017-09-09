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
                                                  billing_email: "meow@meow.org",
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
  describe "user app account update" do
    setup [:create_user_app_account]
    @tag :integration
    test "should not allow user account to have billing email",
         %{user_app_account: user_app_account} do
      assert {:error,
                %{app_account: ["user account does not have billing email"]}} =
               AppAccounts.update_app_account(user_app_account,
                                              %{
                                                new_billing_email: "fake@gmail.org",
                                              })
    end
    @tag :integration
    test "should set primary email verification to false when primary email is updated",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{primary_email: "new@gmail.com"})
      email =
        Enum.find(updated_user_app_account.emails,
                  fn email ->
                    email.address == "new@gmail.com" and email.type == 0
                  end)
      assert email.is_verified == false
    end
    @tag :integration
    test "should set contributor status to true when account is contributor",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{is_contributor: true})
      assert updated_user_app_account.is_contributor == true
    end
    @tag :integration
    test "should set employee status to true when account is employee",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{is_employee: true})
      assert updated_user_app_account.is_employee == true
    end
    @tag :integration
    test "should set activation status to true when account is deactivated",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{is_activated: false})
      assert updated_user_app_account.is_activated == false
    end
    @tag :integration
    test "should set suspension status to true when account is suspended",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{is_suspended: true})
      assert updated_user_app_account.is_suspended == true
    end
    @tag :integration
    test "should update handle name when handle name is available",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{handle_name: "meow2"})
      assert updated_user_app_account.handle_name == "meow2"
    end
    @tag :integration
    test "should update primary email verification to true when correct verification is given",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{primary_email_verification_code: "meow_email_code"})
                                              email =
      Enum.find(updated_user_app_account.emails,
                fn email ->
                  email.address == "meow@gmail.com" and email.type == 0
                end)
      assert email.is_verified == true
    end
  end
  describe "organization app account update" do
    setup [:create_org_app_account]
    @tag :integration
    test "should not allow organization account to have primary email",
         %{org_app_account: org_app_account} do
      assert {:error,
                %{
                  app_account: [
                    "organization account does not have primary email",
                  ],
                }} =
               AppAccounts.update_app_account(org_app_account,
                                              %{primary_email: "woof@woof.org"})
    end
    @tag :integration
    test "should not allow organization account to be tagged as contributor",
         %{org_app_account: org_app_account} do
      assert {:error,
                %{app_account: ["organization cannot be a contributor"]}} =
               AppAccounts.update_app_account(org_app_account,
                                              %{is_contributor: true})
    end
    @tag :integration
    test "should not allow organization account to be tagged as employee",
         %{org_app_account: org_app_account} do
      assert {:error, %{app_account: ["organization cannot be an employee"]}} =
               AppAccounts.update_app_account(org_app_account,
                                              %{is_employee: true})
    end
  end
end
