defmodule StrawHat.Mailer.Query.TemplatePartialQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  def get_by(query, template_id, partial_ids) do
    from template_partial in query,
     where: template_partial.template_id == ^template_id,
     where: template_partial.partial_id in ^partial_ids
  end
end
