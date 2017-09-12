defmodule Plustwo.Domain.AppAccounts.AppAccountsTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppAccounts
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  describe "app account registration" do
    @tag :integration
    test "should succeed with valid user app account data" do
      assert {:ok, %AppAccount{} = user_account} =
               AppAccounts.register_app_account(build(:user_app_account))
      assert user_account.handle_name == "meow"
      assert user_account.is_activated == true
      assert user_account.is_suspended == false
      assert user_account.type == 0
      assert Enum.count(user_account.emails) == 1
      assert Enum.find(user_account.emails, fn email -> email.type == 0 end)
    end
    @tag :integration
    test "should succeed with valid business app account data" do
      assert {:ok, %AppAccount{} = business_account} =
               AppAccounts.register_app_account(build(:business_app_account))
      assert business_account.handle_name == "meow_biz"
      assert business_account.is_activated == false
      assert business_account.is_suspended == false
      assert business_account.type == 1
    end
  end
  describe "user app account registration" do
    setup [:create_user_app_account]
    @tag :integration
    test "should fail when the same handle name already exist" do
      assert {:error, %{handle_name: ["has already been taken"]}} =
               AppAccounts.register_app_account(build(:user_app_account,
                                                      primary_email: "meow2@gmail.com"))
    end
    @tag :integration
    test "should fail when the same primary email address already exist" do
      assert {:error, %{primary_email: ["has already been taken"]}} =
               AppAccounts.register_app_account(build(:user_app_account,
                                                      handle_name: "meow2"))
    end
  end
  describe "business app account registration" do
    setup [:create_business_app_account]
    @tag :integration
    test "should fail when the same handle name already exist" do
      assert {:error, %{handle_name: ["has already been taken"]}} =
               AppAccounts.register_app_account(build(:business_app_account))
    end
  end
  describe "app account query" do
    setup [:create_user_app_account]
    @tag :integration
    test "should be able to retrieve an app account using its UUID",
         %{user_app_account: user_app_account} do
      retrieved = AppAccounts.get_app_account_by_uuid(user_app_account.uuid)
      assert retrieved.uuid == user_app_account.uuid
    end
    @tag :integration
    test "should be able to retrieve an app account using its handle_name",
         %{user_app_account: user_app_account} do
      retrieved = AppAccounts.get_app_account_by_handle_name("meow")
      assert retrieved.uuid == user_app_account.uuid
    end
    @tag :integration
    test "should be able to retrieve a user app account using primary email",
         %{user_app_account: user_app_account} do
      retrieved = AppAccounts.get_app_account_by_primary_email("meow@gmail.com")
      assert retrieved.uuid == user_app_account.uuid
    end
  end
  describe "a user app account update" do
    setup [:create_user_app_account]
    @tag :integration
    test "should succeed when updating account activation status",
         %{user_app_account: user_app_account} do
      assert {:ok, %AppAccount{} = updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{is_activated: false})
      assert updated_user_app_account.is_activated == false
    end
    @tag :integration
    test "should succeed when updating account suspension status",
         %{user_app_account: user_app_account} do
      assert {:ok, %AppAccount{} = updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{is_suspended: true})
      assert updated_user_app_account.is_suspended == true
    end
    @tag :integration
    test "should succeed with valid user name",
         %{user_app_account: user_app_account} do
      assert {:ok, %AppAccount{} = updated_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{
                                                family_name: "meow",
                                                given_name: "is",
                                                middle_name: "awesome",
                                              })
      assert updated_account.user.family_name == "meow"
      assert updated_account.user.given_name == "is"
      assert updated_account.user.middle_name == "awesome"
    end
    @tag :integration
    test "should succeed with valid user birthdate",
         %{user_app_account: user_app_account} do
      assert {:ok, %AppAccount{} = updated_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{
                                                birthdate_day: 1,
                                                birthdate_month: 1,
                                                birthdate_year: 1993,
                                              })
      assert updated_account.user.birthdate_day == 1
      assert updated_account.user.birthdate_month == 1
      assert updated_account.user.birthdate_year == 1993
    end
    @tag :integration
    test "should fail when trying to add a billing email",
         %{user_app_account: user_app_account} do
      assert {:error,
                %{
                  app_account: ["user app account cannot have billing email"],
                }} =
               AppAccounts.update_app_account(user_app_account,
                                              %{
                                                new_billing_email: "fake@gmail.org",
                                              })
    end
    @tag :integration
    test "should fail when trying to remove a billing email",
         %{user_app_account: user_app_account} do
      assert {:error,
                %{
                  app_account: ["user app account cannot have billing email"],
                }} =
               AppAccounts.update_app_account(user_app_account,
                                              %{
                                                remove_billing_email: "fake@gmail.org",
                                              })
    end
    @tag :integration
    test "should set primary email verification to false when primary email is updated",
         %{user_app_account: user_app_account} do
      assert {:ok, updated_user_app_account} =
               AppAccounts.update_app_account(user_app_account,
                                              %{
                                                primary_email: "new_meow@gmail.com",
                                              })
      email =
        Enum.find(updated_user_app_account.emails,
                  fn email ->
                    email.address == "new_meow@gmail.com" and email.type == 0
                  end)
      assert email.is_verified == false
    end
  end
  describe "update a business app account" do
    nil
  end
end
