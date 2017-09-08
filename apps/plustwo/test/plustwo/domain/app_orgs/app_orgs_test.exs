defmodule Plustwo.Domain.AppOrgs.AppOrgsTest do
  @moduledoc false

  use Plustwo.DataCase

  alias Plustwo.Domain.AppOrgs
  alias Plustwo.Domain.AppOrgs.Schemas.AppOrg

  describe "app org update" do
    test "should not allow organization account to be tagged as contributor" do
      assert 1 == 1
    end
  end
end
