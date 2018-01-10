defmodule StrawHat.Mailer.Template do
  @moduledoc """
  Interactor module that defines all the functionality for template management.
  """

  use StrawHat.Mailer.Interactor

  alias StrawHat.Mailer.Schema.{Template, Partial, TemplatePartial}
  alias StrawHat.Mailer.Query.{TemplateQuery, TemplatePartialQuery}

  @doc """
  Get the list of templates.
  """
  @spec get_templates(Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_templates(pagination \\ []) do
    Template
    |> TemplateQuery.templates()
    |> Repo.paginate(pagination)
  end

  @doc """
  Create a template.
  """
  @spec create_template(Template.template_attrs()) ::
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def create_template(template_attrs) do
    %Template{}
    |> Template.changeset(template_attrs)
    |> Repo.insert()
  end

  @doc """
  Update a template.
  """
  @spec update_template(Template.t(), Template.template_attrs()) ::
          {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def update_template(%Template{} = template, template_attrs) do
    template
    |> Template.changeset(template_attrs)
    |> Repo.update()
  end

  @doc """
  Destroy a template.
  """
  @spec destroy_template(Template.t()) :: {:ok, Template.t()} | {:error, Ecto.Changeset.t()}
  def destroy_template(%Template{} = template), do: Repo.delete(template)

  @doc """
  Get a template by `id`.
  """
  @spec find_template(String.t()) :: {:ok, Template.t()} | {:error, Error.t()}
  def find_template(template_id) do
    case get_template(template_id) do
      nil ->
        error =
          Error.new("straw_hat_mailer.template.not_found", metadata: [template_id: template_id])

        {:error, error}

      template ->
        {:ok, template}
    end
  end

  @doc """
  Get a template by `id`.
  """
  @spec get_template(String.t()) :: Ecto.Schema.t() | nil | no_return
  def get_template(template_id) do
    Template
    |> Repo.get(template_id)
    |> Repo.preload(:partials)
  end

  @doc """
  Get a template by `name`.
  """
  @spec get_template_by_name(String.t()) :: {:ok, Template.t()} | {:error, Error.t()}
  def get_template_by_name(template_name) do
    template =
      Template
      |> TemplateQuery.by_name(template_name)
      |> Repo.one()

    case template do
      nil ->
        error =
          Error.new(
            "straw_hat_mailer.template.not_found",
            metadata: [template_name: template_name]
          )

        {:error, error}

      template ->
        {:ok, template}
    end
  end

  @doc """
  Add partials to template.
  """
  @spec add_partials(Template.t(), [Partial.t()]) :: [Template.t() | Ecto.Changeset.t()]
  def add_partials(template, partials) do
    Enum.map(partials, fn %Partial{} = partial ->
      template
      |> add_partial(partial)
      |> elem(1)
    end)
  end

  @doc """
  Add a partial to template.
  """
  @spec add_partial(Template.t(), Partial.t()) ::
          {:ok, TemplatePartial.t()} | {:error, Ecto.Changeset.t()}
  def add_partial(template, partial) do
    %TemplatePartial{}
    |> TemplatePartial.changeset(template, partial)
    |> Repo.insert()
  end

  @doc """
  Remove partials from template.
  """
  @spec remove_partials(Template.t(), [Integer.t()]) :: {integer, nil | [term]} | no_return
  def remove_partials(template, partials) do
    TemplatePartial
    |> TemplatePartialQuery.get_by(template.id, partials)
    |> Repo.delete_all()
  end
end
