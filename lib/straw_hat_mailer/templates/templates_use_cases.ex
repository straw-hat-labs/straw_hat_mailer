defmodule StrawHat.Mailer.Templates do
  @moduledoc """
  Interactor module that defines all the functionality for template management.
  """

  import Ecto.Query
  alias StrawHat.{Error, Response}
  alias StrawHat.Mailer.{Template, TemplatePartial, Partial}

  @spec get_templates(Ecto.Repo.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_templates(repo, pagination \\ []) do
    templates_with_partials() |> Scrivener.paginate(Scrivener.Config.new(repo, [], pagination))
  end

  @spec create_template(Ecto.Repo.t(), Template.template_attrs()) ::
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def create_template(repo, template_attrs) do
    %Template{}
    |> Template.changeset(template_attrs)
    |> repo.insert()
  end

  @spec update_template(Ecto.Repo.t(), Template.t(), Template.template_attrs()) ::
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def update_template(repo, %Template{} = template, template_attrs) do
    template
    |> Template.changeset(template_attrs)
    |> repo.update()
  end

  @spec destroy_template(Ecto.Repo.t(), Template.t()) :: {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def destroy_template(repo, %Template{} = template) do
    repo.delete(template)
  end

  @spec change_template(Template.t()) :: Ecto.Changeset.t()
  def change_template(%Template{} = template) do
    Template.changeset(template, %{})
  end

  @spec find_template(Ecto.Repo.t(), String.t()) :: {:ok, Template.t()} | {:error, Error.t()}
  def find_template(repo, template_id) do
    repo
    |> get_template(template_id)
    |> Response.from_value(
      Error.new("straw_hat_mailer.template.not_found", metadata: [template_id: template_id])
    )
  end

  @spec get_template(Ecto.Repo.t(), String.t()) :: Ecto.Schema.t() | nil | no_return
  def get_template(repo, template_id) do
    Template
    |> repo.get(template_id)
    |> repo.preload(:partials)
  end

  @spec get_template_by_name(Ecto.Repo.t(), String.t()) :: {:ok, Template.t()} | {:error, Error.t()}
  def get_template_by_name(repo, template_name) do
    template_name
    |> templates_by_name()
    |> repo.one()
    |> Response.from_value(
      Error.new(
        "straw_hat_mailer.template.not_found",
        metadata: [template_name: template_name]
      )
    )
  end

  @spec add_partials(Ecto.Repo.t(), Template.t(), [Partial.t()]) :: [
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
        ]
  def add_partials(repo, template, partials) do
    Enum.map(partials, &add_partial(repo, template, &1))
  end

  @spec add_partial(Ecto.Repo.t(), Template.t(), Partial.t()) ::
          {:ok, TemplatePartial.t()} | {:error, Ecto.Changeset.t()}
  def add_partial(repo, template, partial) do
    %TemplatePartial{}
    |> TemplatePartial.changeset(template, partial)
    |> repo.insert()
  end

  @spec remove_partial(Ecto.Repo.t(), Template.t(), Partial.t()) ::
          {:ok, TemplatePartial.t()} | {:error, Ecto.Changeset.t() | Error.t()}
  def remove_partial(repo, %Template{id: template_id} = _template, %Partial{id: partial_id} = _partial) do
    clauses = [template_id: template_id, partial_id: partial_id]

    TemplatePartial
    |> repo.get_by(clauses)
    |> Response.from_value(
      Error.new("straw_hat_mailer.template_partial.not_found", metadata: clauses)
    )
    |> Response.map(&repo.delete/1)
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
