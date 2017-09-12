defmodule Plustwo.Domain.AppAccounts.CommandHandlers.BusinessHandler do
  @moduledoc false

  @behaviour Commanded.Commands.Handler
  alias Plustwo.Domain.AppAccounts.Aggregates.Business
  alias Plustwo.Domain.AppAccounts.Commands.{CreateBusiness, UpdateBusiness}
  alias Plustwo.Domain.AppAccounts.Events.{BusinessInfoUpdated,
                                           BusinessContactInfoUpdated,
                                           BusinessCreated}

  @doc "Creates a business."
  def handle(%Business{business_uuid: nil},
             %CreateBusiness{business_uuid: business_uuid,
                             app_account_uuid: app_account_uuid}) do
    %BusinessCreated{business_uuid: business_uuid,
                     app_account_uuid: app_account_uuid}
  end

  @doc "Update business info and contact info."
  def handle(%Business{} = business, %UpdateBusiness{} = update) do
    fns = [&business_info_updated/2, &contact_info_updated/2]
    Enum.reduce fns, [], fn change, events -> case change.(business, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end end
  end


  defp business_info_updated(%Business{},
                             %UpdateBusiness{legal_name: nil,
                                             description: nil,
                                             address: nil}) do
    nil
  end

  defp business_info_updated(%Business{legal_name: legal_name,
                                       description: description,
                                       address: address},
                             %UpdateBusiness{legal_name: legal_name,
                                             description: description,
                                             address: address}) do
    nil
  end

  defp business_info_updated(%Business{business_uuid: business_uuid},
                             %UpdateBusiness{legal_name: legal_name,
                                             description: description,
                                             address: address}) do
    %BusinessInfoUpdated{business_uuid: business_uuid,
                         legal_name: legal_name,
                         description: description,
                         address: address}
  end


  defp contact_info_updated(%Business{},
                            %UpdateBusiness{website_url: nil,
                                            phone_number: nil,
                                            email_address: nil}) do
    nil
  end

  defp contact_info_updated(%Business{website_url: website_url,
                                      phone_number: phone_number,
                                      email_address: email_address},
                            %UpdateBusiness{website_url: website_url,
                                            phone_number: phone_number,
                                            email_address: email_address}) do
    nil
  end

  defp contact_info_updated(%Business{business_uuid: business_uuid},
                            %UpdateBusiness{website_url: website_url,
                                            phone_number: phone_number,
                                            email_address: email_address}) do
    %BusinessContactInfoUpdated{business_uuid: business_uuid,
                                website_url: website_url,
                                phone_number: phone_number,
                                email_address: email_address}
  end
end
