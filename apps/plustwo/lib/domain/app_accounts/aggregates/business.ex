defmodule Plustwo.Domain.AppAccounts.Aggregates.Business do
  @moduledoc "A business entity on Plustwo."

  defstruct business_uuid: nil,
            app_account_uuid: nil,
            legal_name: nil,
            description: nil,
            address: Map.new(),
            website_url: nil,
            phone_number: nil,
            email_address: nil
  alias Plustwo.Domain.AppAccounts.Aggregates.Business
  alias Plustwo.Domain.AppAccounts.Events.{BusinessInfoUpdated,
                                           BusinessContactInfoUpdated,
                                           BusinessCreated}

  def apply(%Business{} = business,
            %BusinessInfoUpdated{legal_name: legal_name,
                                 description: description,
                                 address: address}) do
    %Business{business |
              legal_name: legal_name,
              description: description,
              address: address}
  end

  def apply(%Business{} = business,
            %BusinessContactInfoUpdated{website_url: website_url,
                                        phone_number: phone_number,
                                        email_address: email_address}) do
    %Business{business |
              website_url: website_url,
              phone_number: phone_number,
              email_address: email_address}
  end

  def apply(%Business{} = business,
            %BusinessCreated{business_uuid: business_uuid,
                             app_account_uuid: app_account_uuid}) do
    %Business{business |
              business_uuid: business_uuid,
              app_account_uuid: app_account_uuid}
  end
end
