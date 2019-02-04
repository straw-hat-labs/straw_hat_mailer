defmodule StrawHat.Mailer.Test.EmailsTest do
  use StrawHat.Mailer.TestSupport.CaseTemplate, async: true
  alias StrawHat.Mailer.{Emails, Templates}
  doctest Emails

  @from "siupport@myapp.com"
  @to "acme@acme.com"
  @options %{
    name: "jristo",
    number: "1 000 000",
    company: "Straw-hat",
    address: "POBOX 54634",
    username: "tokarev"
  }

  describe "with_template/2" do
    test "with valid template should match html and text" do
      template = insert(:template)

      {:ok, email} =
        @from
        |> Emails.new(@to)
        |> Emails.with_template(template.name, @options)

      assert email.html_body ==
               "Welcome tokarev!, <br> <b>Become </b> our client number <i>1 000 000</i>"

      assert email.text_body == "Text with name, plain and my number is 1 000 000"
    end

    test "with invalid template it returns an error" do
      assert {:error, _email} =
               @from
               |> Emails.new(@to)
               |> Emails.with_template("fake_id")
    end

    test "with added partials should it renders the partial contents" do
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

      Templates.add_partials(template, [partial])

      {:ok, email} =
        @from
        |> Emails.new(@to)
        |> Emails.with_template(template.name, @options)

      assert email.html_body ==
               "<b>Welcome</b> tokarev!, enjoy a good reputation, <b>Purchase Now!</b>: POBOX 54634"

      assert email.text_body ==
               "Welcome tokarev!, enjoy a good reputation, Purchase Now!: POBOX 54634"
    end
  end

  test "deliver/1 should send the email" do
    options = [subject: "Welcome john"]
    email = Emails.new(@from, @to, options)
    assert {:ok, %{id: _}} = StrawHat.Mailer.deliver(email)
  end

  test "deliver_later/1 should send the email" do
    options = [subject: "Welcome john"]
    email = Emails.new(@from, @to, options)
    assert {:ok, _} = StrawHat.Mailer.deliver_later(email)
  end
end
