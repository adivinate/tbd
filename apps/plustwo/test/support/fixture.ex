defmodule Plustwo.Fixture do
  @moduledoc false

  import Plustwo.Factory

  alias Plustwo.Domain.AppAccounts

  def create_user_app_account(_context) do
    {:ok, user_app_account} = fixture(:user_app_account)
    [user_app_account: user_app_account]
  end


  def create_business_app_account(_context) do
    {:ok, business_app_account} = fixture(:business_app_account)
    [business_app_account: business_app_account]
  end


  def fixture(:user_app_account) do
    :user_app_account
    |> build()
    |> AppAccounts.register_app_account()
  end

  def fixture(:business_app_account) do
    :business_app_account
    |> build()
    |> AppAccounts.register_app_account()
  end
end
