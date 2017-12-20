defmodule StrawHat.Mailer.Query.TemplateQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias StrawHat.Mailer.Schema.Template

  @spec templates(Template.t()) :: Ecto.Query.t()
  def templates(query) do
    from(_template in query, preload: [:partials])
  end

  @spec by_name(Template.t(), String.t()) :: Ecto.Query.t()
  def by_name(query, name) do
    from(
      template in query,
      where: template.name == ^name,
      preload: :partials
    )
  end
end
