defmodule IAMTest.RoleTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.Role

  test "find role" do
    role = insert(:role)

    assert {:ok, _role} = Role.find_role(role.name)
  end

  test "create a role" do
    params = %{
      name: "admin",
      title: Faker.Name.name()}
    assert {:ok, _role} = Role.create_role(params)
  end

  test "duplicated role" do
    params = %{
      name: "admin",
      title: Faker.Name.name()}
    assert {:ok, _role} = Role.create_role(params)
    assert {:error, _reason} = Role.create_role(params)
  end

  test "destroy role" do
    role = insert(:role)
    assert {:ok, _role} = Role.destroy_role(role)
    assert {:error, _reason} = Role.find_role(role.name)
  end

  test "add permission to role" do
    permission = insert(:permission)
    role = insert(:role)

    assert {:ok, _permission_role} = Role.add_permission(role, permission)
  end

  test "add same permission to role twice" do
    permission = insert(:permission)
    role = insert(:role)

    assert {:ok, _permission_role} = Role.add_permission(role, permission)
    assert {:error, _reason} = Role.add_permission(role, permission)
  end

  test "remove permission from role" do
    permission_permission = insert(:role_permission)

    assert {:ok, _permission_role} = Role.remove_permission(permission_permission.role, permission_permission.permission)
  end

  test "get roles by names" do
    role_names =
      insert_list(4, :role)
      |> Enum.map(fn role -> role.name end)

    roles = Role.find_roles_with_names(role_names)

    assert length(roles) == 4
  end
end
