defmodule Plustwo.Domain.Accounts.Queries.AccountEmailQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.Accounts.Schemas.AccountEmail

  def by_account_uuid(account_uuid) do
    where = [account_uuid: account_uuid]
    account_email_query where
  end

  def by_account_uuid(account_uuid, email_type) do
    where = [account_uuid: account_uuid, type: email_type]
    account_email_query where
  end

  def by_account_uuid(account_uuid, email_address, email_type, version) do
    where = [
      account_uuid: account_uuid,
      version: version,
      address: email_address,
      type: email_type,
    ]
    account_email_query where
  end


  def by_address(email_address, email_type) do
    where = [address: email_address, type: email_type]
    account_email_query where
  end


  defp account_email_query(w) do
    from AccountEmail, where: ^(w)
  end
end
