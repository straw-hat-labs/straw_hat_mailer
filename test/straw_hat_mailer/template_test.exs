defmodule StrawHat.Mailer.Test.TemplateTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.Template

  describe "get template" do
    test "with a valid name" do
      template = insert(:template)
      assert {:ok, _template} = Template.get_template_by_name(template.name)
    end

    test "with a valid id" do
      template = insert(:template)
      assert {:ok, _template} = Template.find_template(template.id)
    end

    test "with an invalid name" do
      assert {:error, _reason} = Template.find_template(1235)
    end
  end

  test "listing templates" do
    insert_list(3, :template)
    template_pagination = Template.get_templates(%{page: 1, page_size: 2})

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

  describe "remove partial from template" do
    test "with a valid connected partial" do
      template = insert(:template)
      partial = insert(:partial)
      Template.add_partial(template, partial)
      assert {:ok, _} = Template.remove_partial(template, partial)
    end

    test "with an invalid connected partial" do
      template = insert(:template)
      partial = insert(:partial)
      assert {:error, _} = Template.remove_partial(template, partial)
    end
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
