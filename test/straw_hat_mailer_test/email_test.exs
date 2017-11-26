defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  alias StrawHat.Mailer.Email

  @from "siupport@myapp.com"
  @to "acme@acme.com"

  describe "with template" do
    test "when the template exists" do
      template = insert(:template, partial: nil)
      options = %{number: "1 000 000"}

      email =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, options)

      assert email.html_body == "Welcome , enjoy a good reputation <br> <b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    end

    test "when the template do not exists" do
      options = %{name: "jristo", number: "1 000 000"}

      email =
        @from
        |> Email.new(@to)
        |> Email.with_template("fake_id", options)

      assert email.html_body == nil
    end

    test "with template and struct data" do
      template =
        insert(:template, %{html_body: "Welcome {{account.username}}, enjoy a good reputation"})

      options = %{
          name: "jristo",
          number: "1 000 000",
          company: 'Straw-hat',
          address: 'POBOX 54634',
          account: %{
            username: "jristo"
          }
      }

      email =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, options)

      assert email.html_body == "Straw-hat the best in the market!</br>Welcome jristo, enjoy a good reputation</br>Located in: POBOX 54634"
    end
  end

  test "send email" do
    options = [subject: "Welcome john"]
    email = Email.new(@from, @to, options)
    assert {:ok, %{id: _}} = StrawHat.Mailer.deliver(email)
  end

  test "send email later" do
    options = [subject: "Welcome john"]
    email = Email.new(@from, @to, options)
    assert {:ok, _} = StrawHat.Mailer.deliver_later(email)
  end
end
