defmodule Plustwo.Domain.AppOrgs.Aggregates.AppOrg do
  @moduledoc "An organization on Plustwo."

  defstruct app_org_uuid: nil,
            app_account_uuid: nil,
            type: nil,
            name: nil,
            start_date: nil,
            mission: nil,
            description: nil,
            website_url: nil,
            phone_number: nil,
            email_address: nil,
            members: MapSet.new()
  alias Plustwo.Domain.AppOrgs.Aggregates.AppOrg
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

  def apply(%AppOrg{} = app_org,
            %AppOrgBusinessInfoUpdated{name: name,
                                       start_date: start_date,
                                       mission: mission,
                                       description: description}) do
    %AppOrg{app_org |
            name: name,
            start_date: start_date,
            mission: mission,
            description: description}
  end

  def apply(%AppOrg{} = app_org,
            %AppOrgContactInfoUpdated{website_url: website_url,
                                      phone_number: phone_number,
                                      email_address: email_address}) do
    %AppOrg{app_org |
            website_url: website_url,
            phone_number: phone_number,
            email_address: email_address}
  end

  def apply(%AppOrg{} = app_org,
            %AppOrgCreated{app_org_uuid: app_org_uuid,
                           app_account_uuid: app_account_uuid,
                           type: type}) do
    %AppOrg{app_org |
            app_org_uuid: app_org_uuid,
            app_account_uuid: app_account_uuid,
            type: type}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMemberMarkedAsAdmin{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_admin,
                                   true)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMemberMarkedAsNonAdmin{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_admin,
                                   false)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMemberMarkedAsNonOwner{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_owner,
                                   false)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMemberMarkedAsNonRepresentative{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_representative,
                                   false)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMemberMarkedAsOwner{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_owner,
                                   true)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMemberMarkedAsRepresentative{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_representative,
                                   true)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMemberRemoved{} = removed) do
    %AppOrg{app_org | members: remove_member(members, removed)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMembershipSetPrivate{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_membership_visible_to_public,
                                   false)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %AppOrgMembershipSetPublic{member_app_account_uuid: member_app_account_uuid}) do
    %AppOrg{app_org |
            members: update_member(members,
                                   member_app_account_uuid,
                                   :is_membership_visible_to_public,
                                   true)}
  end

  def apply(%AppOrg{members: members} = app_org,
            %NewAppOrgMemberAdded{new_member_app_account_uuid: new_member_app_account_uuid}) do
    %AppOrg{app_org |
            members: MapSet.put(members,
                                %{
                                  app_account_uuid: new_member_app_account_uuid,
                                  is_owner: false,
                                  is_representative: false,
                                  is_admin: false,
                                  is_membership_visible_to_public: false,
                                })}
  end


  defp remove_member(members,
                     %AppOrgMemberRemoved{member_app_account_uuid: member_app_account_uuid}) do
    current_member =
      Enum.find(members,
                fn member ->
                  member.app_account_uuid == member_app_account_uuid
                end)
    MapSet.delete members, current_member
  end


  defp update_member(members, app_account_uuid, key, value) do
    MapSet.new members, fn
                 %{app_account_uuid: ^(app_account_uuid)} = old ->
                   %{old | key => value}

                 any ->
                   any
               end
  end
end
