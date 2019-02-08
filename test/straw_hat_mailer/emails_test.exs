defmodule StrawHat.Mailer.Test.EmailsTests do
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

  test "applying the template" do
    template = insert(:template)
    email = Emails.new(@from, @to)
    {:ok, email} = Emails.with_template(Repo, email, template.name, @options)

    assert email.html_body ==
             "Welcome tokarev!, <br> <b>Become </b> our client number <i>1 000 000</i>"

    assert email.text_body == "Text with name, plain and my number is 1 000 000"
  end

  test "applying the template with an invalid template ID" do
    email = Emails.new(@from, @to)

    assert {:error, _email} = Emails.with_template(Repo, email, "fake_id", %{})
  end

  test "applying the template with partials" do
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

    Templates.add_partials(Repo, template, [partial])

    email = Emails.new(@from, @to)

    {:ok, email} = Emails.with_template(Repo, email, template.name, @options)

    assert email.html_body ==
             "<b>Welcome</b> tokarev!, enjoy a good reputation, <b>Purchase Now!</b>: POBOX 54634"

    assert email.text_body ==
             "Welcome tokarev!, enjoy a good reputation, Purchase Now!: POBOX 54634"
  end

  test "delivering an email syncronizely" do
    options = [subject: "Welcome john"]
    email = Emails.new(@from, @to, options)

    assert {:ok, %{id: _}} = StrawHat.Mailer.deliver(email)
  end

  test "delivering an email asyncronizely" do
    options = [subject: "Welcome john"]
    email = Emails.new(@from, @to, options)

    assert {:ok, _} = StrawHat.Mailer.deliver_later(email)
  end
end
