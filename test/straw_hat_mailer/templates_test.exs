defmodule StrawHat.Mailer.TemplateTests do
  use StrawHat.Mailer.TestSupport.CaseTemplate, async: true
  alias StrawHat.Mailer.{Templates, Template}
  doctest Templates

  test "finding a template by name" do
    template = insert(:template)

    assert {:ok, _template} = Templates.get_template_by_name(Repo, template.name)
  end

  test "returning a pagination of templates" do
    insert_list(3, :template)
    template_pagination = Templates.get_templates(Repo, %{page: 1, page_size: 2})

    assert length(template_pagination.entries) == 2
  end

  describe "finding a template" do
    test "with a valid ID" do
      template = insert(:template)

      assert {:ok, _template} = Templates.find_template(Repo, template.id)
    end

    test "with an invalid ID" do
      template_id = Ecto.UUID.generate()

      assert {:error, _reason} = Templates.find_template(Repo, template_id)
    end
  end

  test "creating a templat with valid inputs" do
    params = params_for(:template)

    assert {:ok, _template} = Templates.create_template(Repo, params)
  end

  test "attaching partials to a template with valid partials" do
    template = insert(:template)
    Templates.add_partials(Repo, template, insert_list(3, :partial))
    Templates.add_partials(Repo, template, insert_list(3, :partial))
    template = Templates.get_template(Repo, template.id)

    assert Enum.count(template.partials) == 6
  end

  describe "removing a partial from the template" do
    test "with a valid connected partial" do
      template = insert(:template)
      partial = insert(:partial)
      Templates.add_partial(Repo, template, partial)

      assert {:ok, _} = Templates.remove_partial(Repo, template, partial)
    end

    test "with an invalid connected partial" do
      template = insert(:template)
      partial = insert(:partial)

      assert {:error, _} = Templates.remove_partial(Repo, template, partial)
    end
  end

  test "updating a template with valid inputs" do
    template = insert(:template)
    {:ok, template} = Templates.update_template(Repo, template, %{name: "new_service"})

    assert template.name == "new_service"
  end

  test "destroying an existing template" do
    template = insert(:template)

    assert {:ok, _} = Templates.destroy_template(Repo, template)
  end

  test "generating a template changeset" do
    assert %Ecto.Changeset{} = Templates.change_template(%Template{})
  end
end
