defmodule StrawHat.Mailer.PartialsTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.{Partials, Partial}
  doctest Partials

  describe "get_owner_partials/2" do
    test "with a valid owner id returns the list of partials" do
      owner_id = "user:123"
      insert_list(3, :partial, %{owner_id: owner_id})
      partial_pagination = Partials.get_owner_partials(owner_id)

      assert length(partial_pagination.entries) == 3
    end

    test "with an invalid owner returns an empty list" do
      insert_list(3, :partial, %{owner_id: "user:123"})
      partial_pagination = Partials.get_owner_partials("admin:1234")

      assert partial_pagination.entries == []
    end
  end

  test "get_partial/1 with a valid id finds the partial" do
    partial = insert(:partial)
    assert Partials.get_partial(partial.id) != nil
  end

  test "get_partial/1 with a invalid id returns an error" do
    assert {:error, _reason} = Partials.find_partial(1235)
  end

  test "get_partials/1 returns a list of partials" do
    insert_list(3, :partial)
    partial = Partials.get_partials(%{page: 2, page_size: 2})
    assert length(partial.entries) == 1
  end

  test "create partial" do
    params = params_for(:partial)
    assert {:ok, _partial} = Partials.create_partial(params)
  end

  test "update_partial/2 with valid data updates the partial" do
    partial = insert(:partial)
    {:ok, partial} = Partials.update_partial(partial, %{text: "Real location {{location}}"})
    assert partial.text == "Real location {{location}}"
  end

  test "delete_partial/1 with valid partial deletes the partial" do
    partial = insert(:partial)
    assert {:ok, _} = Partials.destroy_partial(partial)
  end

  test "change_partial/1 returns a partial changeset" do
    assert %Ecto.Changeset{} = Partials.change_partial(%Partial{})
  end
end
