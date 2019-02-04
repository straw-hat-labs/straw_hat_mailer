defmodule StrawHat.Mailer.TemplateTest do
  use StrawHat.Mailer.TestSupport.CaseTemplate, async: true
  alias StrawHat.Mailer.{Templates, Template}
  doctest Templates

  test "get_template_by_name/1 with a valid name returns a template" do
    template = insert(:template)
    assert {:ok, _template} = Templates.get_template_by_name(template.name)
  end

  test "find_template/1 with a valid id returns a template" do
    template = insert(:template)
    assert {:ok, _template} = Templates.find_template(template.id)
  end

  describe "find_template/1" do
    test "with an invalid name returns an error" do
      assert {:error, _reason} = Ecto.UUID.generate() |> Templates.find_template()
    end

    test "returns a pagination of templates" do
      insert_list(3, :template)
      template_pagination = Templates.get_templates(%{page: 1, page_size: 2})

      assert length(template_pagination.entries) == 2
    end
  end

  test "create_template/1 with valid data creates a template" do
    params = params_for(:template)
    assert {:ok, _template} = Templates.create_template(params)
  end

  test "add_partials/2 with valid partials attached the partials to the template" do
    template = insert(:template)
    Templates.add_partials(template, insert_list(3, :partial))
    Templates.add_partials(template, insert_list(3, :partial))
    template = Templates.get_template(template.id)
    assert Enum.count(template.partials) == 6
  end

  describe "remove_partial/2" do
    test "with valid connected partial removes the partial from the template" do
      template = insert(:template)
      partial = insert(:partial)
      Templates.add_partial(template, partial)
      assert {:ok, _} = Templates.remove_partial(template, partial)
    end

    test "with an invalid connected partial returns an error" do
      template = insert(:template)
      partial = insert(:partial)
      assert {:error, _} = Templates.remove_partial(template, partial)
    end
  end

  test "update_template/2 with valid data updates the template" do
    template = insert(:template)
    {:ok, template} = Templates.update_template(template, %{name: "new_service"})
    assert template.name == "new_service"
  end

  test "destroy_template/1 with valid template destroys the template" do
    template = insert(:template)
    assert {:ok, _} = Templates.destroy_template(template)
  end

  test "change_template/1 returns a template changeset" do
    assert %Ecto.Changeset{} = Templates.change_template(%Template{})
  end
end
