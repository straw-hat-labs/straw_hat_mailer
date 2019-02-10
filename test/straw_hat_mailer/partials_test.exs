defmodule StrawHat.Mailer.PartialsTests do
  use StrawHat.Mailer.TestSupport.CaseTemplate, async: true
  alias StrawHat.Mailer.{Partials, Partial}
  doctest Partials

  describe "getting a list of partials by owner ID" do
    test "returns a pagination of partials" do
      owner_id = "user:123"
      insert_list(3, :partial, %{owner_id: owner_id})
      partial_pagination = Partials.get_owner_partials(Repo, owner_id)

      assert length(partial_pagination.entries) == 3
    end

    test "returns a pagination of partials with empty entries" do
      insert_list(3, :partial, %{owner_id: "user:123"})
      partial_pagination = Partials.get_owner_partials(Repo, "admin:1234")

      assert partial_pagination.entries == []
    end
  end

  describe "finding a partial" do
    test "with a valid ID" do
      partial = insert(:partial)

      assert {:ok, _partial} = Partials.find_partial(Repo, partial.id)
    end

    test "with an invalid ID" do
      partial_id = Ecto.UUID.generate()

      assert {:error, _reason} = Partials.find_partial(Repo, partial_id)
    end
  end

  test "returning a pagination of partials" do
    insert_list(3, :partial)
    partial_page = Partials.get_partials(Repo, %{page: 2, page_size: 2})

    assert length(partial_page.entries) == 1
  end

  test "creating a partial with valid inputs" do
    params = params_for(:partial)

    assert {:ok, _partial} = Partials.create_partial(Repo, params)
  end

  test "updating a partial with valid inputs" do
    partial = insert(:partial)
    {:ok, partial} = Partials.update_partial(Repo, partial, %{text: "Real location {{location}}"})

    assert partial.text == "Real location {{location}}"
  end

  test "destroying an existing partial" do
    partial = insert(:partial)

    assert {:ok, _} = Partials.destroy_partial(Repo, partial)
  end

  test "returning a partial changeset" do
    assert %Ecto.Changeset{} = Partials.change_partial(%Partial{})
  end
end
