defmodule Plustwo.Domain.Accounts.Commands.RegisterAccount do
  @moduledoc false

  defstruct uuid: "",
            is_org: false,
            handle_name: "",
            org_owner_account_uuid: "",
            email: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.Accounts.Commands.RegisterAccount
  alias Plustwo.Domain.Accounts.Validators.{UniqueAccountHandleName,
                                            UniqueAccountPrimaryEmail,
                                            AccountUuidMustExist}

  validates :uuid, presence: true, uuid: true
  validates :is_org, boolean: true
  validates :handle_name,
            presence: true,
            string: true,
            handle_name: true,
            length: [min: 2],
            by: [
              function: &UniqueAccountHandleName.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]
  validates :org_owner_account_uuid,
            presence: [if: [is_org: true]],
            uuid: true,
            by: [
              function: &AccountUuidMustExist.validate/2,
              allow_blank: true,
              allow_nil: nil,
            ]
  validates :email,
            presence: true,
            string: true,
            email: true,
            by: [
              function: &UniqueAccountPrimaryEmail.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]

  @doc "Assign a unique identity to account."
  def assign_uuid(%RegisterAccount{} = user, uuid) do
    %RegisterAccount{user | uuid: uuid}
  end


  @doc "Downcase account handle name."
  def downcase_handle_name(%RegisterAccount{handle_name: handle_name} =
                             account) do
    %RegisterAccount{account | handle_name: String.downcase(handle_name)}
  end


  @doc "Downcase account email."
  def downcase_email(%RegisterAccount{email: email} = account) do
    %RegisterAccount{account | email: String.downcase(email)}
  end
end
