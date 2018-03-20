defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  alias StrawHat.Mailer.{Email, Template}

  @from "siupport@myapp.com"
  @to "acme@acme.com"
  @options %{
    name: "jristo",
    number: "1 000 000",
    company: "Straw-hat",
    address: "POBOX 54634",
    username: "tokarev"
  }

  describe "email with template" do
    test "should match html and text" do
      template = insert(:template)

      {:ok, email} =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, @options)

      assert email.html_body ==
               "Welcome tokarev!, <br> <b>Become </b> our client number <i>1 000 000</i>"

      assert email.text_body == "Text with name, plain and my number is 1 000 000"
    end

    test "when the template doesn't exists" do
      assert {:error, _email} =
               @from
               |> Email.new(@to)
               |> Email.with_template("fake_id")
    end

    test "with partials" do
      template_attrs = %{
        html:
          "<b>Welcome</b> {{data.username}}!, enjoy a good reputation, {{{partials.marketing_text}}}",
        text: "Welcome {{data.username}}!, enjoy a good reputation, {{partials.marketing_text}}"
      }

      partial_attrs = %{
        name: "marketing_text",
        html: "<b>Purchase Now!</b>: {{data.address}}",
        text: "Purchase Now!: {{data.address}}"
      }

      template = insert(:template, template_attrs)
      partial = insert(:partial, partial_attrs)

      Template.add_partials(template, [partial])

      {:ok, email} =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, @options)

      assert email.html_body ==
               "<b>Welcome</b> tokarev!, enjoy a good reputation, <b>Purchase Now!</b>: POBOX 54634"

      assert email.text_body ==
               "Welcome tokarev!, enjoy a good reputation, Purchase Now!: POBOX 54634"
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
