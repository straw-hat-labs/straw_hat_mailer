defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  alias StrawHat.Mailer.Email

  test "email with template" do
    template = insert(:template)
    assert %Swoosh.Email{} = email =  Email.template(template.name, %{name: "jristo", number: "1 000 000"})
    assert email.html_body == "<b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    assert email.text_body == "Welcome jristo, enjoy a good reputation"
  end

  test "email without template" do
    assert %Swoosh.Email{} = Email.template("fake_name", %{name: "jristo", number: "1 000 000"})
  end
end
