defmodule StrawHat.Mailer.Template do
  alias StrawHat.Error
  alias StrawHat.Mailer.Repo
  alias StrawHat.Mailer.Schema.Template

  def get_templates(paginate), do: Repo.paginate(Template, paginate)

  def create_template(params) do
    %Template{}
    |> Template.changeset(params)
    |> Repo.insert()
  end

  def update_template(%Template{} = template, params) do
    template
    |> Template.changeset(params)
    |> Repo.update()
  end

  def destroy_template(%Template{} = template), do: Repo.delete(template)

  def find_template(id) do
    case get_template(id) do
      nil -> {:error, Error.new("mailer.template.not_found", metadata: [id: id])}
      template -> {:ok, template}
    end
  end

  def get_template(id), do: Repo.get(Template, id)

  def get_template_by_name(template_name)do
    Template
    |> Repo.get_by(name: template_name)
    |> case do
      nil ->
        error = Error.new("mailer.template.not_found", metadata: [template_name: template_name])
        {:error, error}
      template -> {:ok, template}
    end
  end
end
