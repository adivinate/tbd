defmodule Plustwo.Domain.AppAccounts.Workflows.SendPrimaryEmailVerificationCodeTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Infrastructure.Components.{Crypto, EmailVerification}

  describe "an email verification code" do
    setup [:create_user_app_account]
    @tag :integration
    test "should be created when a new user account is registered",
         %{user_app_account: user_app_account} do
      :timer.sleep :timer.seconds(3)
      email_verification_code_hash =
        EmailVerification.get_code_hash(%{
                                          app_account_uuid: user_app_account.uuid,
                                          email_type: 0,
                                        })
      comparison_result =
        Crypto.verify("email_code", email_verification_code_hash, :bcrypt)
      assert email_verification_code_hash != nil
      assert comparison_result == true
    end
  end
end
