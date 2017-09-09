defmodule Plustwo.Domain.AppAccounts.Workflows.SendPrimaryEmailVerificationCodeTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppAccounts
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount
  alias Plustwo.Infrastructure.Components.EmailVerification

  describe "an email verification code" do
    setup [:create_user_app_account]
    @tag :integration
    test "should be created when a new user account is registered", %{user_app_account: user_app_account} do
      :timer.sleep :timer.seconds(3)
      email_verification_code_hash =
        EmailVerification.get_code_hash(%{
                                          app_account_uuid: user_app_account.uuid,
                                          email_type: 0,
                                        })
      assert email_verification_code_hash != nil
      assert email_verification_code_hash != ""
    end
  end
end
