defmodule IAMTest.GraphQL.AuthorizePermissionMiddlewareTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.GraphQL.Middleware.AuthorizePermission

  test "call with authenticated account" do
    permissions = [%StrawHat.IAM.Schema.Permission{name: "admin", service: "iam"}]
    account = build(:account, %{permissions: permissions})
    resolution_config = [name: "admin", service: "iam"]
    resolution = %{context: %{current_account: account}, state: :unresolved, errors: []}

    assert ^resolution = AuthorizePermission.call(resolution, resolution_config)
  end

  test "call with guest account" do
    permissions = [%StrawHat.IAM.Schema.Permission{name: "guest", service: "iam"}]
    account = build(:guest_account, %{permissions: permissions})

    resolution_config = [name: "guest", service: "iam"]
    resolution = %{context: %{current_account: account}, state: :unresolved, errors: []}

    assert ^resolution = AuthorizePermission.call(resolution, resolution_config)
  end

  test "call fail" do
    permissions = [%StrawHat.IAM.Schema.Permission{name: "guest", service: "iam"}]
    account = build(:account, %{permissions: permissions})
    resolution_config = [name: "admin", service: "iam"]
    resolution = %{context: %{current_account: account}, state: :unresolved, errors: []}

    resolution_fail = AuthorizePermission.call(resolution, resolution_config)

    assert resolution_fail.errors != []
  end
end
