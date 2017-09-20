defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  alias StrawHat.Mailer.Email

  test "email with template" do
    template = insert(:template)
    options = %{name: "jristo", number: "1 000 000"}

    email = Email.new_email("john@gmail.com", "support@myapp.com")
    email = Email.with_template(email, template.name, options)

    assert email.html_body == "<b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    assert email.text_body == "Welcome jristo, enjoy a good reputation"
  end

  test "email with template and struct data" do
    template = insert(:template, %{text_body: "Welcome {{account.username}}, enjoy a good reputation"})
    options = %{
        name: "jristo",
        number: "1 000 000",
        account: %{
          username: "jristo"
        }
    }
    email = Email.new_email("john@gmail.com", "support@myapp.com")
    email = Email.with_template(email, template.name,  options)

    assert email.html_body == "<b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    assert email.text_body == "Welcome jristo, enjoy a good reputation"
  end

  test "email without template" do
    options = %{subject: "Welcome john"}
    assert %Swoosh.Email{} = Email.new_email("john@gmail.com", "support@myapp.com", options)
  end

  test "send email" do
    options = %{subject: "Welcome john"}
    email = Email.new_email("john@gmail.com", "support@myapp.com", options)
    assert {:ok, %{id: _}} = Email.send_email(email)
  end

  test "send email later" do
    options = %{subject: "Welcome john"}
    email = Email.new_email("john@gmail.com", "support@myapp.com", options)
    assert {:ok, _} = Email.send_email_later(email)
  end
end
