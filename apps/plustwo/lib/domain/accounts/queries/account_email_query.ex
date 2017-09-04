defmodule Plustwo.Domain.Accounts.Queries.AccountEmailQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.Accounts.Schemas.AccountEmail

  def by_account_uuid(account_uuid, opt) do
    where = [account_uuid: account_uuid]
    account_email_query where, opt
  end

  def by_account_uuid(account_uuid, email_type, opt) do
    where = [account_uuid: account_uuid, type: email_type]
    account_email_query where, opt
  end

  def by_account_uuid(account_uuid, email_address, email_type, version, opt) do
    where = [
      account_uuid: account_uuid,
      version: version,
      address: email_address,
      type: email_type,
    ]
    account_email_query where, opt
  end


  @selected_field [:id, :version, :account_uuid, :address, :type, :is_verified]
  def account_email_query() do
    from AccountEmail, select: ^@selected_field
  end
  def account_email_query(w, opt) do
    case opt do
      :no_assoc ->
        from AccountEmail, where: ^(w)

      :with_assoc ->
        from AccountEmail, select: ^(@selected_field), where: ^(w)
    end
  end
end
