defmodule StrawHat.Mailer.Query.TemplateQuery do
  import Ecto.Query, only: [from: 2]

  def by_name(query, name) do
    from template in query,
      where: template.name == ^name,
       preload: :partial
  end
end
