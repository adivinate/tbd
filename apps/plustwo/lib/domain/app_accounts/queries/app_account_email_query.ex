defmodule Plustwo.Domain.AppAccounts.Queries.AppAccountEmailQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccountEmail

  def by_app_account_uuid(app_account_uuid) do
    where = [app_account_uuid: app_account_uuid]
    app_account_email_query where
  end

  def by_app_account_uuid(app_account_uuid, email_type) do
    where = [app_account_uuid: app_account_uuid, type: email_type]
    app_account_email_query where
  end

  def by_app_account_uuid(app_account_uuid,
                          email_address,
                          email_type,
                          version) do
    where = [
      app_account_uuid: app_account_uuid,
      version: version,
      address: email_address,
      type: email_type,
    ]
    app_account_email_query where
  end


  def by_address(email_address, email_type) do
    where = [address: email_address, type: email_type]
    app_account_email_query where
  end


  defp app_account_email_query(w) do
    from AppAccountEmail, where: ^(w)
  end
end
