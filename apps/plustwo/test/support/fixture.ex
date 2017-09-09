defmodule Plustwo.Fixture do
  @moduledoc false

  import Plustwo.Factory

  alias Plustwo.Domain.{AppAccounts,
                        AppOrgs,
                        AppUsers}

  def create_user_app_account(_context) do
    {:ok, user_app_account} = fixture(:user_app_account)
    [user_app_account: user_app_account]
  end


  def create_org_app_account(_context) do
    {:ok, org_app_account} = fixture(:org_app_account)
    [org_app_account: org_app_account]
  end


  def get_app_user(%{user_app_account: user_app_account}) do
    :timer.sleep :timer.seconds(3)
    app_user = AppUsers.get_app_user_by_app_account_uuid(user_app_account.uuid)
    [app_user: app_user]
  end


  def get_app_org(%{org_app_account: org_app_account}) do
    :timer.sleep :timer.seconds(3)
    app_org = AppOrgs.get_app_org_by_app_account_uuid(org_app_account.uuid)
    [app_org: app_org]
  end


  def fixture(:org_app_account) do
    :org_app_account
    |> build()
    |> AppAccounts.register_app_account()
  end

  def fixture(:user_app_account) do
    :user_app_account
    |> build()
    |> AppAccounts.register_app_account()
  end
end
