defmodule Plustwo.Domain.AppAccounts.Queries.BusinessQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.AppAccounts.Schemas.Business

  def by_uuid(uuid) do
    where = [uuid: uuid]
    business_query where
  end

  def by_uuid(uuid, version) do
    where = [uuid: uuid, version: version]
    business_query where
  end


  def by_app_account_uuid(app_account_uuid) do
    where = [app_account_uuid: app_account_uuid]
    business_query where
  end


  defp business_query(w) do
    from Business, where: ^(w)
  end
end
