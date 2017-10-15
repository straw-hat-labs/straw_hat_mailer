defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  alias StrawHat.Mailer.Email

  describe "with template" do
    test "when the template exists" do
      template = insert(:template)
      options = %{name: "jristo", number: "1 000 000"}

      email = Email.new("support@myapp.com", "john@gmail.com")
      email = Email.with_template(email, template.name, options)

      assert email.html_body == "Welcome jristo, enjoy a good reputation <br> <b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    end

    test "when the template do not exists" do
      options = %{name: "jristo", number: "1 000 000"}

      email = Email.new("support@myapp.com", "john@gmail.com")
      email = Email.with_template(email, "fake_id", options)

      assert email.html_body == nil
    end

    test "with template and struct data" do
      template = insert(:template, %{html_body: "Welcome {{account.username}}, enjoy a good reputation"})
      options = %{
          name: "jristo",
          number: "1 000 000",
          account: %{
            username: "jristo"
          }
      }
      email = Email.new("support@myapp.com", "john@gmail.com")
      email = Email.with_template(email, template.name,  options)

      assert email.html_body == "Welcome jristo, enjoy a good reputation"
    end
  end

  test "send email" do
    options = [subject: "Welcome john"]
    email = Email.new("support@myapp.com", "john@gmail.com", options)
    assert {:ok, %{id: _}} = StrawHat.Mailer.deliver(email)
  end

  test "send email later" do
    options = [subject: "Welcome john"]
    email = Email.new("support@myapp.com", "john@gmail.com", options)
    assert {:ok, _} = StrawHat.Mailer.deliver_later(email)
  end
end
