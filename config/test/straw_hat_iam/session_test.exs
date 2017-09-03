defmodule IAMTest.SessionTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.Session

  test "create a session" do
    account = insert(:account)
    credentials = %{
      email: account.email,
      password: "generalpassword12345"}

    assert {:ok, _session, _account} = Session.create_session(credentials)
  end

  test "create a session token" do
    account = insert(:account)

    assert {:ok, _session, _account} = Session.create_session_token(account)
  end
end
