defmodule IAMTest.Factory do
  use ExMachina.Ecto, repo: StrawHat.IAM.Repo
  alias StrawHat.IAM.Schema.{
    Role, Permission, RolePermission, Account, AccountRole, GuestAccount}

  def base64(length \\ 8) do
    :crypto.strong_rand_bytes(length) |> Base.encode64()
  end

  def role_factory do
    %Role{
      name: base64(),
      title: Faker.Name.name(),
      description: Faker.Lorem.Shakespeare.as_you_like_it(),
      status: "enabled",
      permissions: build_list(1, :permission)}
  end

  def permission_factory do
    %Permission{
      name: Faker.Name.name(),
      service: Faker.Name.name()}
  end

  def role_permission_factory do
    %RolePermission{
      role: build(:role),
      permission: build(:permission)}
  end

  def account_factory do
    password = "generalpassword12345"
    encrypted_password = StrawHat.IAM.Auth.generate_hashed_password(password)

    %Account{
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: password,
      encrypted_password: encrypted_password,
      roles: build_list(1, :role),
      permissions: build_list(2, :permission)}
  end

  def account_role_factory do
    %AccountRole{
      account: build(:account),
      role: build(:role)}
  end

  def guest_account_factory do
    %GuestAccount{
      roles: build_list(2, :role),
      permissions: build_list(5, :permission)}
  end
end
