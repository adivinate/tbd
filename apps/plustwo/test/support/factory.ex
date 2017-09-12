defmodule Plustwo.Factory do
  @moduledoc false

  use ExMachina

  def user_app_account_factory do
    %{type: 0, handle_name: "meow", primary_email: "meow@gmail.com"}
  end


  def business_app_account_factory do
    %{type: 1, handle_name: "meow_biz", billing_email: "meow@meow.biz"}
  end
end
