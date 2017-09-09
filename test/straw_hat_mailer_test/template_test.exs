defmodule StrawHat.Mailer.Test.TemplateTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.Template

  test "get by name" do
    template = insert(:template)
    assert {:ok, _template} = Template.template(template.name)
  end

  test "list per page" do
    insert_list(10, :template)
    template = Template.list_templates(%{page: 2, page_size: 5})
    assert template.total_entries == 10
  end

  test "create" do
    params =
      %{name: get_random_string(),
        service: get_random_string(3),
        from: %{
         name: Faker.Name.name(),
         email: Faker.Internet.email()
        },
        subject: "Milka Suberast",
        text_body: "Welcome {{name}}, enjoy a good reputation",
        html_body: "<b>Become </b> our client number <i>{{number}}</i>, enjoy the service."}
    assert {:ok, template} = Template.create_template(params)
  end

  test "update by template" do
    template = insert(:template)
    {:ok, template} = Template.update_template(template, %{name: "new_service"})
    assert template.name == "new_service"
  end

  test "delete by template" do
    template = insert(:template)
    assert {:ok, _} = Template.destroy_template(template)
  end
end
