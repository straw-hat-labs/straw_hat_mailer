defmodule StrawHat.Mailer.Templates do
  @moduledoc """
  Interactor module that defines all the functionality for template management.
  """

  use StrawHat.Mailer.Interactor
  alias StrawHat.Mailer.{Template, TemplatePartial, Partial}

  @spec get_templates(Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_templates(pagination \\ []) do
    templates_with_partials() |> Repo.paginate(pagination)
  end

  @spec create_template(Template.template_attrs()) ::
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def create_template(template_attrs) do
    %Template{}
    |> Template.changeset(template_attrs)
    |> Repo.insert()
  end

  @spec update_template(Template.t(), Template.template_attrs()) ::
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def update_template(%Template{} = template, template_attrs) do
    template
    |> Template.changeset(template_attrs)
    |> Repo.update()
  end

  @spec destroy_template(Template.t()) :: {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def destroy_template(%Template{} = template), do: Repo.delete(template)

  @spec change_template(Template.t()) :: Ecto.Changeset.t()
  def change_template(%Template{} = template) do
    Template.changeset(template, %{})
  end

  @spec find_template(String.t()) :: {:ok, Template.t()} | {:error, Error.t()}
  def find_template(template_id) do
    template_id
    |> get_template()
    |> Response.from_value(
      Error.new("straw_hat_mailer.template.not_found", metadata: [template_id: template_id])
    )
  end

  @spec get_template(String.t()) :: Ecto.Schema.t() | nil | no_return
  def get_template(template_id) do
    Template
    |> Repo.get(template_id)
    |> Repo.preload(:partials)
  end

  @spec get_template_by_name(String.t()) :: {:ok, Template.t()} | {:error, Error.t()}
  def get_template_by_name(template_name) do
    template_name
    |> templates_by_name()
    |> Repo.one()
    |> Response.from_value(
      Error.new(
        "straw_hat_mailer.template.not_found",
        metadata: [template_name: template_name]
      )
    )
  end

  @spec add_partials(Template.t(), [Partial.t()]) :: [
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
        ]
  def add_partials(template, partials) do
    Enum.map(partials, fn %Partial{} = partial ->
      add_partial(template, partial)
    end)
  end

  @spec add_partial(Template.t(), Partial.t()) ::
          {:ok, TemplatePartial.t()} | {:error, Ecto.Changeset.t()}
  def add_partial(template, partial) do
    %TemplatePartial{}
    |> TemplatePartial.changeset(template, partial)
    |> Repo.insert()
  end

  @spec remove_partial(Template.t(), Partial.t()) ::
          {:ok, TemplatePartial.t()} | {:error, Ecto.Changeset.t() | Error.t()}
  def remove_partial(%Template{id: template_id} = _template, %Partial{id: partial_id} = _partial) do
    clauses = [template_id: template_id, partial_id: partial_id]

    TemplatePartial
    |> Repo.get_by(clauses)
    |> Response.from_value(
      Error.new("straw_hat_mailer.template_partial.not_found", metadata: clauses)
    )
    |> Response.map(&Repo.delete/1)
  end

  defp templates_by_name(name) do
    from(
      template in Template,
      where: template.name == ^name,
      preload: [:partials]
    )
  end

  defp templates_with_partials do
    from(_template in Template, preload: [:partials])
  end
end
