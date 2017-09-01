defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  alias StrawHat.Mailer.Email

  test "email with template" do
    template = insert(:template)
    assert %Swoosh.Email{} =  Email.template(template.name, name: "jristo", number: "1 000 000")
  end

  test "email without template" do
    assert %Swoosh.Email{} = Email.template("fake_name", name: "jristo", number: "1 000 000")
  end
end
