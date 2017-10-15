defmodule StrawHat.Mailer.Template do
  @moduledoc """
  Interactor module that defines all the functionality for template management.
  """

  alias StrawHat.Error
  alias StrawHat.Mailer.Repo
  alias StrawHat.Mailer.Schema.Template

  @type template_attrs :: %{
    name: String.t,
    title: String.t,
    subject: String.t,
    owner_id: String.t,
    privacy: Privacy.t,
    html_body: String.t,
  }

  @spec get_templates(Scrivener.Config.t) :: Scrivener.Page.t
  def get_templates(pagination \\ []), do: Repo.paginate(Template, pagination)

  @spec create_template(template_attrs) :: {:ok, Template.t} | {:error, Ecto.Changeset.t}
  def create_template(template_attrs) do
    %Template{}
    |> Template.changeset(template_attrs)
    |> Repo.insert()
  end

  @spec update_template(Template.t, template_attrs) :: {:ok, Template.t} | {:error, Ecto.Changeset.t}
  def update_template(%Template{} = template, template_attrs) do
    template
    |> Template.changeset(template_attrs)
    |> Repo.update()
  end

  @spec destroy_template(Template.t) :: {:ok, Template.t} | {:error, Ecto.Changeset.t}
  def destroy_template(%Template{} = template), do: Repo.delete(template)

  @spec find_template(String.t) :: {:ok, Template.t} | {:error, Error.t}
  def find_template(template_id) do
    case get_template(template_id) do
      nil ->
        error = Error.new("mailer.template.not_found", metadata: [template_id: template_id])
        {:error, error}
      template -> {:ok, template}
    end
  end

  @spec get_template(String.t) :: Ecto.Schema.t | nil | no_return
  def get_template(template_id), do: Repo.get(Template, template_id)

  @spec get_template_by_name(String.t) :: {:ok, Template.t} | {:error, Ecto.Changeset.t}
  def get_template_by_name(template_name) do
    clauses = [name: template_name]

    case Repo.get_by(Template, clauses) do
      nil ->
        error = Error.new("mailer.template.not_found", metadata: [template_name: template_name])
        {:error, error}
      template -> {:ok, template}
    end
  end
end
