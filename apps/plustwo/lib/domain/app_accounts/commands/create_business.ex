defmodule Plustwo.Domain.AppAccounts.Commands.CreateBusiness do
  @moduledoc false

  defstruct business_uuid: nil, app_account_uuid: nil
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppAccounts.Commands.CreateBusiness

  validates :business_uuid, presence: true, uuid: true
  validates :app_account_uuid, presence: true, uuid: true

  @doc "Assigns a unique business identity."
  def assign_business_uuid(%CreateBusiness{} = business, business_uuid) do
    %CreateBusiness{business | business_uuid: business_uuid}
  end


  @doc "Assigns app account UUID."
  def assign_app_account_uuid(%CreateBusiness{} = business, app_account_uuid) do
    %CreateBusiness{business | app_account_uuid: app_account_uuid}
  end
end
