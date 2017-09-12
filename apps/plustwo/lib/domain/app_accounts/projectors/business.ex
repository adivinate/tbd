defmodule Plustwo.Domain.AppAccounts.Projectors.Business do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "AppAccounts.Projectors.Business"

  alias Ecto.Multi
  alias Plustwo.Domain.AppAccounts.Notifications
  alias Plustwo.Domain.AppAccounts.Schemas.Business
  alias Plustwo.Domain.AppAccounts.Queries.BusinessQuery
  alias Plustwo.Domain.AppAccounts.Events.{BusinessInfoUpdated,
                                           BusinessContactInfoUpdated,
                                           BusinessCreated}

  project %BusinessInfoUpdated{business_uuid: business_uuid,
                               legal_name: legal_name,
                               description: description,
                               address: address},
          metadata do
    update_business multi,
                    business_uuid,
                    metadata,
                    legal_name: legal_name,
                    legal_lname: String.downcase(legal_name),
                    description: description,
                    address_street: address.street,
                    address_locality: address.locality,
                    address_region: address.region,
                    address_postal_code: address.postal_code
  end
  project %BusinessContactInfoUpdated{business_uuid: business_uuid,
                                      website_url: website_url,
                                      phone_number: phone_number,
                                      email_address: email_address},
          metadata do
    update_business multi,
                    business_uuid,
                    metadata,
                    website_url: website_url,
                    phone_number: phone_number,
                    email_address: email_address
  end
  project %BusinessCreated{business_uuid: business_uuid,
                           app_account_uuid: app_account_uuid},
          %{stream_version: stream_version} do
    Multi.insert multi,
                 :business,
                 %Business{uuid: business_uuid,
                           version: stream_version,
                           app_account_uuid: app_account_uuid}
  end
  def after_update(_event, _metadata, changes) do
    Notifications.publish_changes changes
  end


  defp update_business(multi,
                       business_uuid,
                       %{stream_version: stream_version},
                       changes) do
    Multi.update_all multi,
                     :business,
                     BusinessQuery.by_uuid(business_uuid),
                     [set: changes ++ [version: stream_version]],
                     returning: true
  end
end
