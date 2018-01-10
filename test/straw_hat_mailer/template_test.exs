defmodule StrawHat.Mailer.Test.TemplateTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.Template

  describe "get template" do
    test "with valid name" do
      template = insert(:template)
      assert {:ok, _template} = Template.get_template_by_name(template.name)
    end

    test "with valid id" do
      template = insert(:template)
      assert {:ok, _template} = Template.find_template(template.id)
    end

    test "with invalid name" do
      assert {:error, _reason} = Template.find_template(1235)
    end
  end

  test "get template by id" do
    template = insert(:template)
    assert Template.get_template(template.id) != nil
  end

  test "list per page" do
    insert_list(5, :template)
    template_pagination = Template.get_templates(%{page: 2, page_size: 2})

    assert length(template_pagination.entries) == 2
  end

  test "create template" do
    params = params_for(:template)
    assert {:ok, _template} = Template.create_template(params)
  end

  test "add partials to template" do
    template = insert(:template)
    Template.add_partials(template, insert_list(3, :partial))
    Template.add_partials(template, insert_list(3, :partial))
    template = Template.get_template(template.id)
    assert Enum.count(template.partials) == 6
  end

  test "remove partials from template" do
    template = insert(:template)
    partial = insert(:partial)
    Template.add_partials(template, [partial])
    assert {count, _} = Template.remove_partials(template, [partial.id])
    assert count == 1
  end

  test "update template" do
    template = insert(:template)
    {:ok, template} = Template.update_template(template, %{name: "new_service"})
    assert template.name == "new_service"
  end

  test "delete template" do
    template = insert(:template)
    assert {:ok, _} = Template.destroy_template(template)
  end
end
