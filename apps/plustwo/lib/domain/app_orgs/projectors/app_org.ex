defmodule Plustwo.Domain.AppOrgs.Projectors.AppOrg do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "AppOrgs.Projectors.AppOrg"

  alias Plustwo.Domain.AppOrgs.Notifications
  alias Plustwo.Domain.AppOrgs.Schemas.{AppOrg, AppOrgMember}
  alias Plustwo.Domain.AppOrgs.Queries.{AppOrgQuery, AppOrgMemberQuery}
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

  project %AppOrgBusinessInfoUpdated{app_org_uuid: app_org_uuid,
                                     name: name,
                                     start_date: start_date,
                                     mission: mission,
                                     description: description},
          metadata do
    update_app_org multi,
                   app_org_uuid,
                   metadata,
                   name: name,
                   start_date: start_date,
                   mission: mission,
                   description: description
  end
  project %AppOrgContactInfoUpdated{app_org_uuid: app_org_uuid,
                                    website_url: website_url,
                                    phone_number: phone_number,
                                    email_address: email_address},
          metadata do
    update_app_org multi,
                   app_org_uuid,
                   metadata,
                   website_url: website_url,
                   phone_number: phone_number,
                   email_address: email_address
  end
  project %AppOrgCreated{app_org_uuid: app_org_uuid,
                         app_account_uuid: app_account_uuid},
          %{stream_version: stream_version} do
    Ecto.Multi.insert multi,
                      :app_org,
                      %AppOrg{uuid: app_org_uuid,
                              version: stream_version,
                              app_account_uuid: app_account_uuid}
  end
  project %AppOrgMemberMarkedAsAdmin{app_org_uuid: app_org_uuid,
                                     member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_admin: true
  end
  project %AppOrgMemberMarkedAsNonAdmin{app_org_uuid: app_org_uuid,
                                        member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_admin: false
  end
  project %AppOrgMemberMarkedAsNonOwner{app_org_uuid: app_org_uuid,
                                        member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_owner: false
  end
  project %AppOrgMemberMarkedAsNonRepresentative{app_org_uuid: app_org_uuid,
                                                 member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_representative: false
  end
  project %AppOrgMemberMarkedAsOwner{app_org_uuid: app_org_uuid,
                                     member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_owner: true
  end
  project %AppOrgMemberMarkedAsRepresentative{app_org_uuid: app_org_uuid,
                                              member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_representative: true
  end
  project %AppOrgMemberRemoved{app_org_uuid: app_org_uuid,
                               member_app_account_uuid: member_app_account_uuid},
          _metadata do
    Ecto.Multi.delete_all multi,
                          :app_org_member,
                          AppOrgMemberQuery.by_app_org_uuid(app_org_uuid,
                                                            member_app_account_uuid),
                          returning: true
  end
  project %AppOrgMembershipSetPrivate{app_org_uuid: app_org_uuid,
                                      member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_membership_visible_to_public: false
  end
  project %AppOrgMembershipSetPublic{app_org_uuid: app_org_uuid,
                                     member_app_account_uuid: member_app_account_uuid},
          metadata do
    update_app_org_member multi,
                          app_org_uuid,
                          member_app_account_uuid,
                          metadata,
                          is_membership_visible_to_public: true
  end
  project %NewAppOrgMemberAdded{app_org_uuid: app_org_uuid,
                                new_member_app_account_uuid: new_member_app_account_uuid},
          %{stream_version: stream_version} do
    Ecto.Multi.insert multi,
                      :app_org_member,
                      %AppOrgMember{app_org_uuid: app_org_uuid,
                                    version: stream_version,
                                    app_account_uuid: new_member_app_account_uuid,
                                    is_owner: false,
                                    is_representative: false,
                                    is_admin: false,
                                    is_membership_visible_to_public: false}
  end
  def after_update(_event, _metadata, changes) do
    Notifications.publish_changes changes
  end


  defp update_app_org(multi,
                      app_org_uuid,
                      %{stream_version: stream_version},
                      changes) do
    Ecto.Multi.update_all multi,
                          :app_org,
                          AppOrgQuery.by_uuid(app_org_uuid),
                          [set: changes ++ [version: stream_version]],
                          returning: true
  end


  defp update_app_org_member(multi,
                             app_org_uuid,
                             app_account_uuid,
                             %{stream_version: stream_version},
                             changes) do
    Ecto.Multi.update_all multi,
                          :app_org_member,
                          AppOrgMemberQuery.by_app_org_uuid(app_org_uuid,
                                                            app_account_uuid),
                          [set: changes ++ [version: stream_version]],
                          returning: true
  end
end
