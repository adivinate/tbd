defmodule Plustwo.Factory do
  @moduledoc false

  use ExMachina

  alias Plustwo.Domain.AppAccounts.Commands.{RegisterAppAccount,
                                             UpdateAppAccount}

  def user_app_account_factory do
    %{is_org: false, handle_name: "meow", primary_email: "meow@gmail.com"}
  end


  def org_app_account_factory do
    %{is_org: true, handle_name: "meow_org", billing_email: "meow@meow.org"}
  end
end
