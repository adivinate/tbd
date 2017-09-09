defmodule Plustwo.Domain.AppOrgs.AppOrgsTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppOrgs
  alias Plustwo.Domain.AppOrgs.Schemas.AppOrg

  describe "app org update" do
    setup [:create_org_app_account, :get_app_org]
    @tag :integration
    test "should succeed with valid business info", %{app_org: app_org} do
      assert {:ok, %AppOrg{} = updated_app_org} =
               AppOrgs.update_app_org(app_org,
                                      %{
                                        name: "Meow Org",
                                        start_date: "",
                                        mission: "To dominate the world with meow power",
                                        description: "An org for meows only. No humans, no woofs.",
                                      })
      assert updated_app_org.name == "Meow Org"
      assert updated_app_org.start_date == nil
      assert updated_app_org.mission == "To dominate the world with meow power"
      assert updated_app_org.description ==
               "An org for meows only. No humans, no woofs."
    end
    @tag :integration
    test "should succeed with valid contact info", %{app_org: app_org} do
      assert {:ok, %AppOrg{} = updated_app_org} =
               AppOrgs.update_app_org(app_org,
                                      %{
                                        website_url: "https://meow.world",
                                        phone_number: "+14442229999",
                                        email_address: "noreply@meow.org",
                                      })
      assert updated_app_org.website_url == "https://meow.world"
      assert updated_app_org.phone_number == "+14442229999"
      assert updated_app_org.email_address == "noreply@meow.org"
    end
  end
end
