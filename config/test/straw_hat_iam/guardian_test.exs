defmodule IAMTest.GuardianTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.Guardian

  test "subject_for_token/2" do
    account = insert(:account)
    param = "account:#{account.id}"

    assert {:ok, ^param} = Guardian.subject_for_token(account, [])
  end

  test "resource_from_claims" do
    permissions = insert_list(1, :permission)
    account = insert(:account, permissions: permissions)
    claims = %{ "sub" => "account:" <> to_string(account.id) }

    assert {:ok, _account} = Guardian.resource_from_claims(claims)
  end
end
