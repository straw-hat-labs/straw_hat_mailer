defmodule StrawHat.Mailer.Query.TemplateQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias StrawHat.Mailer.Schema.Template

  @spec templates :: Ecto.Query.t()
  def templates do
    from(_template in Template, preload: [:partials])
  end

  @spec templates_by_name(String.t()) :: Ecto.Query.t()
  def templates_by_name(name) do
    from(
      template in Template,
      where: template.name == ^name,
      preload: [:partials]
    )
  end
end
