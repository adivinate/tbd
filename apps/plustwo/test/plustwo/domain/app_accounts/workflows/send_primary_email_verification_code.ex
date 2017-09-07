defmodule Plustwo.Domain.AppAccounts.Workflows.SendPrimaryEmailVerificationCodeTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppAccounts
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount
  alias Plustwo.Infrastructure.Components.EmailVerification

  describe "an email verification code" do
    @tag :integration
    test "should be created when a new user account is registered" do
      assert {:ok, %AppAccount{} = app_account} =
               AppAccounts.register_app_account(%{
                                                  is_org: false,
                                                  handle_name: "meow",
                                                  email: "meow@gmail.com",
                                                })
      :timer.sleep :timer.seconds(5)
      email_verification_code_hash =
        EmailVerification.get_code_hash(%{
                                          app_account_uuid: app_account.uuid,
                                          email_type: 0,
                                        })
      assert email_verification_code_hash != nil
      assert email_verification_code_hash != ""
    end
  end
end
