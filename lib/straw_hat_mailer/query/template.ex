defmodule StrawHat.Mailer.Query.TemplateQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  @spec by_name(Template.t(), String.t()) :: Ecto.Query.t()
  def by_name(query, name) do
    from(
      template in query,
      where: template.name == ^name,
      preload: :partials
    )
  end
end
