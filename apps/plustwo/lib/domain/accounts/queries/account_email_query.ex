defmodule Plustwo.Domain.Accounts.Queries.AccountEmailQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.Accounts.Schemas.AccountEmail

  @selected_field [
    :id,
    :version,
    :account_uuid,
    :address,
    :type,
    :is_verified,
  ]

  def by_account_uuid(account_uuid) do
    where = [account_uuid: account_uuid]
    email_query(where)
  end
  def by_account_uuid(account_uuid, version) do
    where = [
      account_uuid: account_uuid,
      version: version,
    ]
    email_query(where)
  end

  def email_query() do
    from AccountEmail, select: ^@selected_field
  end
  def email_query(w) do
    from AccountEmail,
      where: ^w,
      select: ^@selected_field
  end
end
