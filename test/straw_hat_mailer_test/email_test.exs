defmodule StrawHat.Mailer.Test.EmailTest do
  use StrawHat.Mailer.Test.DataCase, async: true

  alias StrawHat.Mailer.Email

  @from "siupport@myapp.com"
  @to "acme@acme.com"
  @options %{
     name: "jristo",
     number: "1 000 000",
     company: "Straw-hat",
     address: "POBOX 54634",
     account: %{
       username: "tokarev"
     }
  }

  describe "with template" do
    test "when the template use html in body" do
      template = insert(:template, partial: nil, text_body: nil)
      email =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, @options)

      assert email.html_body == "<span style=\"display: none !important;\">Behold then sings my soul</span></br>Welcome, enjoy a good reputation <br> <b>Become </b> our client number <i>1 000 000</i>, enjoy the service."
    end

    test "when the template use text plain in body" do
      template = insert(:template, html_body: nil)
      email =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, @options)

      assert email.text_body == "Behold then sings my soul\n\n\nStraw-hat the best in the market!\nText with name, plain and my number is 1 000 000\nLocated in: POBOX 54634"
    end

    test "when the template use text plain in body without: pre_header and partials" do
      template = insert(:template, pre_header: nil, partial: nil, html_body: nil)
      email =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, @options)

      assert email.text_body == "Text with name, plain and my number is 1 000 000"
    end

    test "when the template body is empty" do
      template = insert(:template, html_body: nil, text_body: nil)
      email =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name, @options)

      assert email.text_body == "Behold then sings my soul\n\n\nStraw-hat the best in the market!\nLocated in: POBOX 54634"
    end

    test "when the template do not exists" do
      email =
        @from
        |> Email.new(@to)
        |> Email.with_template("fake_id", @options)

      assert email.html_body == nil
    end

    test "with template and struct data" do
      template = insert(:template, %{html_body: "Welcome {{account.username}}, enjoy a good reputation"})
      email =
        @from
        |> Email.new(@to)
        |> Email.with_template(template.name,  @options)

      assert email.html_body == "<span style=\"display: none !important;\">Behold then sings my soul</span></br>Straw-hat the best in the market!</br>Welcome tokarev, enjoy a good reputation</br>Located in: POBOX 54634"
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
