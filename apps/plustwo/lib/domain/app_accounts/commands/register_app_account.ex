defmodule Plustwo.Domain.AppAccounts.Commands.RegisterAppAccount do
  @moduledoc false

  defstruct app_account_uuid: nil,
            type: nil,
            handle_name: nil,
            primary_email: nil,
            billing_email: nil
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppAccounts.Commands.RegisterAppAccount
  alias Plustwo.Domain.AppAccounts.Validators.{UniqueAppAccountHandleName,
                                               UniqueAppAccountPrimaryEmail}

  validates :app_account_uuid, presence: true, uuid: true
  validates :type,
            presence: true,
            integer: true,
            inclusion: [in: 0..1, allow_nil: false, allow_blank: false]
  validates :handle_name,
            presence: true,
            string: true,
            handle_name: true,
            length: [min: 2],
            by: [
              function: &UniqueAppAccountHandleName.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]
  validates :primary_email,
            presence: [if: [type: 0]],
            string: true,
            email: true,
            by: [
              function: &UniqueAppAccountPrimaryEmail.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]
  validates :billing_email, presence: [if: [type: 1]], string: true, email: true

  @doc "Assigns UUID to app account."
  def assign_app_account_uuid(%RegisterAppAccount{} = app_account,
                              app_account_uuid) do
    %RegisterAppAccount{app_account | app_account_uuid: app_account_uuid}
  end


  @doc "Downcases app account handle name."
  def downcase_handle_name(%RegisterAppAccount{handle_name: handle_name} =
                             app_account) do
    %RegisterAppAccount{app_account | handle_name: String.downcase(handle_name)}
  end


  @doc "Downcases app account primary email."
  def downcase_primary_email(%RegisterAppAccount{primary_email: primary_email} =
                               app_account) do
    %RegisterAppAccount{app_account |
                        primary_email: String.downcase(primary_email)}
  end


  @doc "Downcases app account billing email."
  def downcase_billing_email(%RegisterAppAccount{billing_email: billing_email} =
                               app_account) do
    %RegisterAppAccount{app_account |
                        billing_email: String.downcase(billing_email)}
  end
end
