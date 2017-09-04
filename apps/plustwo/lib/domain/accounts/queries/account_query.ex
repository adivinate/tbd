defmodule Plustwo.Domain.Accounts.Queries.AccountQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.Accounts.Queries.AccountEmailQuery
  alias Plustwo.Domain.Accounts.Schemas.Account

  # this is useful for Multi `update_all`
  def by_uuid(uuid, opt) do
    where = [uuid: uuid]
    account_query where, opt
  end

  def by_uuid(uuid, version, opt) do
    where = [uuid: uuid, version: version]
    account_query where, opt
  end


  def by_handle_name(handle_name, opt) do
    where = [handle_name: handle_name]
    account_query where, opt
  end

  @selected_field [
    :uuid,
    :version,
    :is_activated,
    :is_suspended,
    :is_employee,
    :is_contributor,
    :is_org,
    :handle_name,
    :joined_at,
  ]
  defp account_query(w, opt) do
    case opt do
      :no_assoc ->
        from Account, where: ^(w)

      :with_assoc ->
        from Account,
             preload: [emails: ^(AccountEmailQuery.account_email_query())],
             select: ^(@selected_field),
             where: ^(w)
    end
  end
end
