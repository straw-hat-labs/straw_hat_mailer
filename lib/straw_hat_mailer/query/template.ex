defmodule StrawHat.Mailer.Query.TemplateQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  def by_name(query, name) do
    from template in query,
      where: template.name == ^name,
       preload: :partials
  end
end
