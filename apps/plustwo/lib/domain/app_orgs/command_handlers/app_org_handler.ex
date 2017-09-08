defmodule Plustwo.Domain.AppOrgs.CommandHandlers.AppOrgHandler do
  @moduledoc false

  @behaviour Commanded.Commands.Handler
  alias Plustwo.Domain.AppOrgs.Aggregates.AppOrg
  alias Plustwo.Domain.AppOrgs.Commands.{CreateAppOrg,
                                         UpdateAppOrgMember,
                                         UpdateAppOrg}
  alias Plustwo.Domain.AppOrgs.Events.{AppOrgBusinessInfoUpdated,
                                       AppOrgContactInfoUpdated,
                                       AppOrgCreated,
                                       AppOrgMemberMarkedAsAdmin,
                                       AppOrgMemberMarkedAsNonAdmin,
                                       AppOrgMemberMarkedAsNonOwner,
                                       AppOrgMemberMarkedAsNonRepresentative,
                                       AppOrgMemberMarkedAsOwner,
                                       AppOrgMemberMarkedAsRepresentative,
                                       AppOrgMemberRemoved,
                                       AppOrgMembershipSetPrivate,
                                       AppOrgMembershipSetPublic,
                                       NewAppOrgMemberAdded}

  @doc "Creates an app organization."
  def handle(%AppOrg{app_org_uuid: nil}, %CreateAppOrg{} = create) do
    %AppOrgCreated{app_org_uuid: create.app_org_uuid,
                   app_account_uuid: create.app_account_uuid}
  end

  @doc "Update an app organization business and contact info."
  def handle(%AppOrg{} = app_org, %UpdateAppOrg{} = update) do
    fns = [&business_info_updated/2, &contact_info_updated/2]
    Enum.reduce fns, [], fn change, events -> case change.(app_org, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end end
  end

  @doc "Update a member of an app organization."
  def handle(%AppOrg{} = app_org, %UpdateAppOrgMember{} = update) do
    fns = [
      &new_member_added/2,
      &member_removed/2,
      &member_admin_status_updated/2,
      &member_owner_status_updated/2,
      &member_representative_status_updated/2,
      &membership_visibility_updated/2,
    ]
    Enum.reduce fns, [], fn change, events -> case change.(app_org, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end end
  end


  defp business_info_updated(%AppOrg{},
                             %UpdateAppOrg{name: nil,
                                           start_date: nil,
                                           mission: nil,
                                           description: nil}) do
    nil
  end

  defp business_info_updated(%AppOrg{name: name,
                                     start_date: start_date,
                                     mission: mission,
                                     description: description},
                             %UpdateAppOrg{name: name,
                                           start_date: start_date,
                                           mission: mission,
                                           description: description}) do
    nil
  end

  defp business_info_updated(%AppOrg{app_org_uuid: app_org_uuid},
                             %UpdateAppOrg{name: name,
                                           start_date: start_date,
                                           mission: mission,
                                           description: description}) do
    %AppOrgBusinessInfoUpdated{app_org_uuid: app_org_uuid,
                               name: name,
                               start_date: start_date,
                               mission: mission,
                               description: description}
  end


  defp contact_info_updated(%AppOrg{},
                            %UpdateAppOrg{website_url: nil,
                                          phone_number: nil,
                                          email_address: nil}) do
    nil
  end

  defp contact_info_updated(%AppOrg{website_url: website_url,
                                    phone_number: phone_number,
                                    email_address: email_address},
                            %UpdateAppOrg{website_url: website_url,
                                          phone_number: phone_number,
                                          email_address: email_address}) do
    nil
  end

  defp contact_info_updated(%AppOrg{app_org_uuid: app_org_uuid},
                            %UpdateAppOrg{website_url: website_url,
                                          phone_number: phone_number,
                                          email_address: email_address}) do
    %AppOrgContactInfoUpdated{app_org_uuid: app_org_uuid,
                              website_url: website_url,
                              phone_number: phone_number,
                              email_address: email_address}
  end


  defp new_member_added(%AppOrg{},
                        %UpdateAppOrgMember{app_account_uuid: nil,
                                            is_new: nil}) do
    nil
  end

  defp new_member_added(%AppOrg{},
                        %UpdateAppOrgMember{app_account_uuid: "",
                                            is_new: ""}) do
    nil
  end

  defp new_member_added(%AppOrg{app_org_uuid: app_org_uuid, members: members},
                        %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                            is_new: true}) do
    case Enum.find(members,
                   fn member ->
                     member.app_account_uuid == app_account_uuid
                   end) do
      nil ->
        %NewAppOrgMemberAdded{app_org_uuid: app_org_uuid,
                              new_member_app_account_uuid: app_account_uuid}

      _ ->
        {:error, %{app_org: ["member already exists"]}}
    end
  end


  defp member_removed(%AppOrg{},
                      %UpdateAppOrgMember{app_account_uuid: nil,
                                          is_remove: nil}) do
    nil
  end

  defp member_removed(%AppOrg{},
                      %UpdateAppOrgMember{app_account_uuid: "",
                                          is_remove: ""}) do
    nil
  end

  defp member_removed(%AppOrg{app_org_uuid: app_org_uuid, members: members},
                      %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                          is_remove: true}) do
    case Enum.find(members,
                   fn member ->
                     member.app_account_uuid == app_account_uuid
                   end) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      _ ->
        %AppOrgMemberRemoved{app_org_uuid: app_org_uuid,
                             member_app_account_uuid: app_account_uuid}
    end
  end


  defp member_admin_status_updated(%AppOrg{},
                                   %UpdateAppOrgMember{app_account_uuid: nil,
                                                       is_admin: nil}) do
    nil
  end

  defp member_admin_status_updated(%AppOrg{},
                                   %UpdateAppOrgMember{app_account_uuid: "",
                                                       is_admin: ""}) do
    nil
  end

  defp member_admin_status_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                           members: members},
                                   %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                       is_admin: false}) do
    case check_member_attribute(members, app_account_uuid, :is_admin, false) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMemberMarkedAsNonAdmin{app_org_uuid: app_org_uuid,
                                      member_app_account_uuid: app_account_uuid}
    end
  end

  defp member_admin_status_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                           members: members},
                                   %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                       is_admin: true}) do
    case check_member_attribute(members, app_account_uuid, :is_admin, true) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMemberMarkedAsAdmin{app_org_uuid: app_org_uuid,
                                   member_app_account_uuid: app_account_uuid}
    end
  end


  defp member_owner_status_updated(%AppOrg{},
                                   %UpdateAppOrgMember{app_account_uuid: nil,
                                                       is_owner: nil}) do
    nil
  end

  defp member_owner_status_updated(%AppOrg{},
                                   %UpdateAppOrgMember{app_account_uuid: "",
                                                       is_owner: ""}) do
    nil
  end

  defp member_owner_status_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                           members: members},
                                   %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                       is_owner: false}) do
    case check_member_attribute(members, app_account_uuid, :is_owner, false) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMemberMarkedAsNonOwner{app_org_uuid: app_org_uuid,
                                      member_app_account_uuid: app_account_uuid}
    end
  end

  defp member_owner_status_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                           members: members},
                                   %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                       is_owner: true}) do
    case check_member_attribute(members, app_account_uuid, :is_owner, true) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMemberMarkedAsOwner{app_org_uuid: app_org_uuid,
                                   member_app_account_uuid: app_account_uuid}
    end
  end


  defp member_representative_status_updated(%AppOrg{},
                                            %UpdateAppOrgMember{app_account_uuid: nil,
                                                                is_representative: nil}) do
    nil
  end

  defp member_representative_status_updated(%AppOrg{},
                                            %UpdateAppOrgMember{app_account_uuid: "",
                                                                is_representative: ""}) do
    nil
  end

  defp member_representative_status_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                                    members: members},
                                            %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                                is_representative: false}) do
    case check_member_attribute(members, app_account_uuid, :is_owner, false) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMemberMarkedAsNonRepresentative{app_org_uuid: app_org_uuid,
                                               member_app_account_uuid: app_account_uuid}
    end
  end

  defp member_representative_status_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                                    members: members},
                                            %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                                is_representative: true}) do
    case check_member_attribute(members, app_account_uuid, :is_owner, true) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMemberMarkedAsRepresentative{app_org_uuid: app_org_uuid,
                                            member_app_account_uuid: app_account_uuid}
    end
  end


  defp membership_visibility_updated(%AppOrg{},
                                     %UpdateAppOrgMember{app_account_uuid: nil,
                                                         is_membership_visible_to_public: nil}) do
    nil
  end

  defp membership_visibility_updated(%AppOrg{},
                                     %UpdateAppOrgMember{app_account_uuid: "",
                                                         is_membership_visible_to_public: ""}) do
    nil
  end

  defp membership_visibility_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                             members: members},
                                     %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                         is_membership_visible_to_public: false}) do
    case check_member_attribute(members,
                                app_account_uuid,
                                :is_membership_visible_to_public,
                                false) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMembershipSetPrivate{app_org_uuid: app_org_uuid,
                                    member_app_account_uuid: app_account_uuid}
    end
  end

  defp membership_visibility_updated(%AppOrg{app_org_uuid: app_org_uuid,
                                             members: members},
                                     %UpdateAppOrgMember{app_account_uuid: app_account_uuid,
                                                         is_membership_visible_to_public: true}) do
    case check_member_attribute(members,
                                app_account_uuid,
                                :is_membership_visible_to_public,
                                true) do
      nil ->
        {:error, %{app_org: ["member does not exist"]}}

      true ->
        nil

      false ->
        %AppOrgMembershipSetPublic{app_org_uuid: app_org_uuid,
                                   member_app_account_uuid: app_account_uuid}
    end
  end


  # Check an attribute of a member from a list. Returns `nil` if member
  # is not on list. If not, it will return truthy value based on the comparison
  # of the attribute value and given value.
  defp check_member_attribute(members, app_account_uuid, key, value) do
    case Enum.find(members,
                   fn member ->
                     member.app_account_uuid == app_account_uuid
                   end) do
      nil ->
        nil

      member ->
        Map.get(member, key) == value
    end
  end
end
