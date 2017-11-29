defmodule StrawHat.Mailer.Test.PartialTest do
  use StrawHat.Mailer.Test.DataCase, async: true
  alias StrawHat.Mailer.Partial

  describe "get partial by owner" do
    test "with valid owner" do
      partial = insert(:partial)
      assert {:ok, _partial} = Partial.get_partial_by_owner(partial.owner_id)
    end

    test "with invalid id" do
      assert {:error, _reason} = Partial.find_partial(1235)
    end

    test "with invalid owner" do
      assert {:error, _reason} = Partial.get_partial_by_owner("1235")
    end
  end

  test "get partial by id" do
    partial = insert(:partial)
    assert Partial.get_partial(partial.id) != nil
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
    {:ok, partial} = Partial.update_partial(partial, %{text_footer: "Real location {{location}}"})
    assert partial.text_footer == "Real location {{location}}"
  end

  test "delete partial" do
    partial = insert(:partial)
    assert {:ok, _} = Partial.destroy_partial(partial)
  end
end
