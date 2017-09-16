defmodule StrawHat.Mailer.Template do
  alias StrawHat.Error
  alias StrawHat.Mailer.Repo
  alias StrawHat.Mailer.Schema.Template

  def get_templates(pagination \\ []), do: Repo.paginate(Template, pagination)

  def create_template(template_attrs) do
    %Template{}
    |> Template.changeset(template_attrs)
    |> Repo.insert()
  end

  def update_template(%Template{} = template, template_attrs) do
    template
    |> Template.changeset(template_attrs)
    |> Repo.update()
  end

  def destroy_template(%Template{} = template), do: Repo.delete(template)

  def find_template(template_id) do
    case get_template(template_id) do
      nil ->
        error = Error.new("mailer.template.not_found", metadata: [template_id: template_id])
        {:error, error}
      template -> {:ok, template}
    end
  end

  def get_template(template_id), do: Repo.get(Template, template_id)

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
