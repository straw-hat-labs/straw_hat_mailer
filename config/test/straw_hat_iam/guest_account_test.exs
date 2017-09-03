defmodule IAMTest.GuestAccountTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.GuestAccount

  test "get guest account" do
    role = insert(:role, %{name: "guest"})
    insert_list(3, :role_permission, %{role: role})

    assert %StrawHat.IAM.Schema.GuestAccount{permissions: permissions} = GuestAccount.get_guest_account()
    assert length(permissions) == 3
  end
end
