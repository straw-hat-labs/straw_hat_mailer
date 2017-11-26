defmodule StrawHat.Mailer.Query.TemplateQuery do
  import Ecto.Query, only: [from: 2]

  def by_name(query, name) do
    from locker in query,
      where: locker.name == ^name,
       preload: :partial
  end
end
