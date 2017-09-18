defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  import StrawHat.Mailer.Email

  test "email with template" do
    template = insert(:template)
    options = %{
      name: "jristo",
      number: "1 000 000"
    }
    email =
      new_email(
        to: "john@gmail.com",
        from: "support@myapp.com",
        template: template.name,
        options: options
      )

    assert email.html_body == "<b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    assert email.text_body == "Welcome jristo, enjoy a good reputation"
  end

  test "email with template and struct data" do
    template = insert(:template, %{text_body: "Welcome {{account.username}}, enjoy a good reputation"})
    options = %{
      number: "1 000 000",
      account: %{
        username: "jristo"
      }
    }
    email =
      new_email(
        to: "john@gmail.com",
        from: "support@myapp.com",
        template: template.name,
        options: options
      )

    assert email.html_body == "<b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    assert email.text_body == "Welcome jristo, enjoy a good reputation"
  end

  test "email without template" do
    assert %Swoosh.Email{} =
      new_email(
        to: "john@gmail.com",
        from: "support@myapp.com",
        subject: "Welcome john"
      )
  end

  test "send email" do
    assert {:ok, %{id: _}} =
      new_email(
        to: "john@gmail.com",
        from: "support@myapp.com",
        subject: "Welcome john"
      ) |> send()
  end

  test "send email later" do
    assert {:ok, _} =
      new_email(
        to: "john@gmail.com",
        from: "support@myapp.com",
        subject: "Welcome john"
      ) |> send_later()
  end
end
