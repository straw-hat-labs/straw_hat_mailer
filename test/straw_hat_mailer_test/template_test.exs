defmodule StrawHat.Mailer.Test.TemplateTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.Template

  test "get by name" do
    template = insert(:template)
    assert {:ok, _template} = Template.get_template_by_name(template.name)
  end

  test "list per page" do
    insert_list(10, :template)
    template = Template.get_templates(%{page: 2, page_size: 5})
    assert template.total_entries == 10
  end

  test "create" do
    params =
      %{name: "welcome",
        title: Faker.String.base64(3),
        subject: "Milka Suberast",
        owner_id: "cargo",
        text_body: "Welcome {{name}}, enjoy a good reputation",
        html_body: "<b>Become </b> our client number <i>{{number}}</i>, enjoy the service."}
    assert {:ok, _template} = Template.create_template(params)
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
