defmodule StrawHat.Mailer.Test.PartialTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.Partial

  describe "get_owner_partials/2" do
    test "with valid owner" do
      owner_id = "user:123"
      partial = insert_list(3, :partial, %{owner_id: owner_id})
      partial_pagination = Partial.get_owner_partials(owner_id)

      assert length(partial_pagination.entries) == 3
    end

    test "with invalid owner" do
      insert_list(3, :partial, %{owner_id: "user:123"})
      partial_pagination = Partial.get_owner_partials("admin:123t")

      assert length(partial_pagination.entries) == 0
    end
  end

  test "get partial by id" do
    partial = insert(:partial)
    assert Partial.get_partial(partial.id) != nil
  end

  test "get partial with invalid id" do
    assert {:error, _reason} = Partial.find_partial(1235)
  end

  test "list per page" do
    insert_list(10, :partial)
    partial = Partial.get_partials(%{page: 2, page_size: 5})
    assert partial.total_entries == 10
  end

  test "create partial" do
    params = params_for(:partial)
    assert {:ok, _partial} = Partial.create_partial(params)
  end

  test "update partial" do
    partial = insert(:partial)
    {:ok, partial} = Partial.update_partial(partial, %{text: "Real location {{location}}"})
    assert partial.text == "Real location {{location}}"
  end

  test "delete partial" do
    partial = insert(:partial)
    assert {:ok, _} = Partial.destroy_partial(partial)
  end
end
