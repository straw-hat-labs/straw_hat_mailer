defmodule StrawHat.Mailer.PartialsTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.Partials
  doctest Partials

  describe "get_owner_partials/2" do
    test "with a valid owner" do
      owner_id = "user:123"
      insert_list(3, :partial, %{owner_id: owner_id})
      partial_pagination = Partials.get_owner_partials(owner_id)

      assert length(partial_pagination.entries) == 3
    end

    test "with an invalid owner" do
      insert_list(3, :partial, %{owner_id: "user:123"})
      partial_pagination = Partials.get_owner_partials("admin:1234")

      assert length(partial_pagination.entries) == 0
    end
  end

  test "get partial by id" do
    partial = insert(:partial)
    assert Partials.get_partial(partial.id) != nil
  end

  test "get partial with invalid id" do
    assert {:error, _reason} = Partials.find_partial(1235)
  end

  test "listing partials" do
    insert_list(3, :partial)
    partial = Partials.get_partials(%{page: 2, page_size: 2})
    assert length(partial.entries) == 1
  end

  test "create partial" do
    params = params_for(:partial)
    assert {:ok, _partial} = Partials.create_partial(params)
  end

  test "update partial" do
    partial = insert(:partial)
    {:ok, partial} = Partials.update_partial(partial, %{text: "Real location {{location}}"})
    assert partial.text == "Real location {{location}}"
  end

  test "delete partial" do
    partial = insert(:partial)
    assert {:ok, _} = Partials.destroy_partial(partial)
  end
end
