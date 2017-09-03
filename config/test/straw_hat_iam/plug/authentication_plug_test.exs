defmodule IAMTest.Plug.AuthenticationPlugTest do
  use IAMTest.DataCase, async: true
  alias StrawHat.IAM.Session
  alias StrawHat.IAM.Plug.Authentication, as: AuthenticationPlug
  alias Plug.Conn

  test "call with authenticated user" do
    account = insert(:account)
    credentials = %{
      email: account.email,
      password: "generalpassword12345"}
    {:ok, session, _account} = Session.create_session(credentials)

    conn = AuthenticationPlug.call(%Conn{req_headers: [{"authorization", "Bearer #{session.access_token}"}]}, %{})

    assert account.email == conn.private.absinthe.context.current_account.email
  end

  test "call" do
    conn = AuthenticationPlug.call(%Conn{}, %{})

    assert %StrawHat.IAM.Schema.GuestAccount{} == conn.private.absinthe.context.current_account
  end
end
