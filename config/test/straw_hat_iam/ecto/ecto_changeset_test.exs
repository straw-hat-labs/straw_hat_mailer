defmodule IAMTest.EctoChangesetTest do
  use IAMTest.DataCase, async: true
  alias Ecto.Changeset, as: EctoChangeset
  alias StrawHat.IAM.Ecto.Changeset
  alias StrawHat.IAM.Schema.Account
  alias StrawHat.IAM.Auth

  test "validate encrypted password match" do
    password = base64(12)
    changeset = EctoChangeset.change(%Account{}, encrypted_password: StrawHat.IAM.Auth.generate_hashed_password(password))

    assert %EctoChangeset{valid?: true} = Changeset.validate_encrypted_password_match(changeset, :encrypted_password, password, [field_name: :current_password])
  end

  test "validate encrypted password match with error" do
    password1 = StrawHat.IAM.Auth.generate_hashed_password("generalpassword12345")
    password2 = StrawHat.IAM.Auth.generate_hashed_password("generalpassword67890")
    changeset = EctoChangeset.change(%Account{}, encrypted_password: password1)

    change = Changeset.validate_encrypted_password_match(changeset, :encrypted_password, password2, [field_name: :current_password])

    assert change.valid? == false
  end

  test "put_password_hash" do
    password = "generalpassword12345"
    changeset = EctoChangeset.change(%Account{}, password: "")
    changeset = Changeset.put_password_hash(changeset, :password, password)

    assert Auth.check_password("generalpassword12345", changeset.changes.password) == true
  end
end
