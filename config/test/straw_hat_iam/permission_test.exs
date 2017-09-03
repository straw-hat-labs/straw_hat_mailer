defmodule IAMTest.PermissionTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.Permission
  alias StrawHat.IAM.Schema.Permission, as: PermissionSchema

  test "has permission?" do
    permissions = build_list(5, :permission)
    permission = List.first(permissions)
    account = %StrawHat.IAM.Schema.Account{permissions: permissions}

    assert true == Permission.has_permission?(account, permission)
  end

  test "is permission?" do
    first_permission = %PermissionSchema{name: "hello", service: "world"}
    second_permission = %PermissionSchema{name: "hello", service: "world"}

    assert true == Permission.is_permission?(first_permission, second_permission)
  end

  test "get permission name" do
    permission = %PermissionSchema{name: "admin", service: "iam"}

    assert "iam:admin" == Permission.get_permission_name(permission)
  end

  test "find permission" do
    permission = insert(:permission)

    assert {:ok, _permission} = Permission.find_permission(permission.id)
  end

  test "get permission" do
    permission1 = insert(:permission)
    permission2 = Permission.get_permission(permission1.id)

    assert true = permission1.id == permission2.id
  end

  test "create a permission" do
    params = %{name: "admin"}
    assert {:ok, _permission} = Permission.create_permission(params)
  end

  test "duplicated permission" do
    params = %{
      name: "admin",
      service: "iam"}

    Permission.create_permission(params)

    assert {:error, _reason} = Permission.create_permission(params)
  end

  test "destroy permission" do
    permission = insert(:permission)
    assert {:ok, _permission} = Permission.destroy_permission(permission)
    assert {:error, _reason} = Permission.find_permission(permission.id)
  end
end
