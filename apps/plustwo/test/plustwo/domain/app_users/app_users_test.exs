defmodule Plustwo.Domain.AppUsers.AppUsersTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppUsers
  alias Plustwo.Domain.AppUsers.Schemas.AppUser

  describe "app user update" do
    setup [:create_user_app_account, :get_app_user]
    @tag :integration
    test "should succeed with valid user name", %{app_user: app_user} do
      assert {:ok, %AppUser{} = updated_app_user} =
               AppUsers.update_app_user(app_user,
                                        %{
                                          family_name: "meow",
                                          given_name: "is",
                                          middle_name: "awesome",
                                        })
      assert updated_app_user.family_name == "meow"
      assert updated_app_user.given_name == "is"
      assert updated_app_user.middle_name == "awesome"
    end
    @tag :integration
    test "should succeed with valid user birthdate", %{app_user: app_user} do
      assert {:ok, %AppUser{} = updated_app_user} =
               AppUsers.update_app_user(app_user,
                                        %{
                                          birthdate_day: 1,
                                          birthdate_month: 1,
                                          birthdate_year: 1993,
                                        })
      assert updated_app_user.birthdate_day == 1
      assert updated_app_user.birthdate_month == 1
      assert updated_app_user.birthdate_year == 1993
    end
    @tag :integration
    test "should fail with invalid user birthdate day", %{app_user: app_user} do
      assert {:error, %{birthdate_day: ["not within range"]}} =
               AppUsers.update_app_user(app_user,
                                        %{
                                          birthdate_day: 32,
                                          birthdate_month: 1,
                                          birthdate_year: 1993,
                                        })
    end
    @tag :integration
    test "should fail with invalid user birthdate month",
         %{app_user: app_user} do
      assert {:error,
                %{
                  birthdate_day: ["invalid birthdate month"],
                  birthdate_month: ["must be one of 1..12"],
                }} =
               AppUsers.update_app_user(app_user,
                                        %{
                                          birthdate_day: 1,
                                          birthdate_month: 13,
                                          birthdate_year: 1993,
                                        })
    end
    @tag :integration
    test "should fail with invalid user birthdate year",
         %{app_user: app_user} do
      assert {:error, %{birthdate_year: ["not within range"]}} =
               AppUsers.update_app_user(app_user,
                                        %{
                                          birthdate_day: 1,
                                          birthdate_month: 1,
                                          birthdate_year: 1800,
                                        })
    end
  end
end
