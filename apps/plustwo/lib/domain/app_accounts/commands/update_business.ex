defmodule Plustwo.Domain.AppAccounts.Commands.UpdateBusiness do
  @moduledoc false

  defstruct business_uuid: nil,
            legal_name: nil,
            description: nil,
            address: nil,
            website_url: nil,
            email_address: nil,
            phone_number: nil
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppAccounts.Commands.UpdateBusiness

  validates :business_uuid, presence: true, uuid: true
  validates :legal_name, string: true
  validates :description, string: true
  # validates :address, address: true
  validates :website_url, string: true
  validates :email_address, string: true
  validates :phone_number, string: true

  @doc "Assigns business UUID."
  def assign_business_uuid(%UpdateBusiness{} = business, business_uuid) do
    %UpdateBusiness{business | business_uuid: business_uuid}
  end
end
