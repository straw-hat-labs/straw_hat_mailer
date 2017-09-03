defmodule IAMTest.AccountTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.Account
  alias StrawHat.IAM.Schema.Account, as: AccountSchema

  @password "newpassword12345"

  test "get account" do
    roles = insert_list(3, :role)
    account = insert(:account, roles: roles)

    assert {:ok, _account} = Account.get_account(%{email: account.email, password: account.password})
  end

  test "get account with permissions" do
    account = insert(:account)
    assert {:ok, _account} = Account.get_account_with_permissions(account.id)
  end

  test "create an account" do
    password = base64(12)
    roles =
      insert_list(4, :role)
      |> Enum.map(fn role -> role.name end)
    params = %{
      email: Faker.Internet.email,
      password: password,
      password_confirmation: password}

    assert {:ok, _account} = Account.create_account(params, roles)
  end

  test "duplicated account" do
    roles =
      insert_list(4, :role)
      |> Enum.map(fn role -> role.name end)
    password = base64(12)
    params = %{
      email: Faker.Internet.email,
      password: password,
      password_confirmation: password}

    Account.create_account(params, roles)

    assert {:error, _reason} = Account.create_account(params, roles)
  end

  test "update an account" do
    account = insert(:account)
    email = Faker.Internet.email
    params = %{email: email}

    assert {:ok, %AccountSchema{email: update_email}} = Account.update_account(account, params)
    assert update_email == email
  end

  test "update an password" do
    account = insert(:account)

    params = %{
      current_password: "generalpassword12345",
      password: @password,
      password_confirmation: @password}

    assert {:ok, %AccountSchema{encrypted_password: password}} = Account.update_password(account, params)
    assert StrawHat.IAM.Auth.check_password(@password, password) == true
  end

  test "remove an account" do
    password = base64(12)
    roles =
      insert_list(1, :role)
      |> Enum.map(fn role -> role.name end)
    params = %{
      email: Faker.Internet.email,
      password: password,
      password_confirmation: password}

    {:ok, %AccountSchema{id: id} = account} = Account.create_account(params, roles)
    assert {:ok, _account} = Account.remove_account(account)
    assert {:error, _reason} = Account.find_account(id)
  end

  test "find account with correct credentials" do
    password = "admin12356789"
    account = insert(:account, %{
      encrypted_password: StrawHat.IAM.Auth.generate_hashed_password(password)})

    params = %{
      password: password,
      email: account.email}

    assert {:ok, _account} = Account.get_account(params)
  end

  test "find account with wrong correct credentials" do
    account = insert(:account)
    params = %{email: "#{account.email}.not_found_email",
               password: "1235567565"}

    assert {:error, _reason} = Account.get_account(params)
  end

  test "add role to account" do
    account = insert(:account)
    role = insert(:role)

    assert {:ok, _account_role} = Account.add_role(account, role)
  end

  test "remove role from account" do
    account_account = insert(:account_role)

    assert {:ok, _account_role} = Account.remove_role(account_account.account, account_account.role)
  end

  test "get accounts by IDs" do
    roles = insert_list(5, :account)
    first_role = Enum.at(roles, 0)
    second_role = Enum.at(roles, 1)
    accounts = Account.account_by_ids([first_role.id, second_role.id])

    assert Enum.at(accounts, 0).id == first_role.id
    assert Enum.at(accounts, 1).id == second_role.id
  end
end
