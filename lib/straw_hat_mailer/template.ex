defmodule StrawHat.Mailer.Template do
  alias StrawHat.Mailer.Query.Template, as: TemplateQuery
  alias StrawHat.Error
  alias StrawHat.Mailer.Repo
  alias StrawHat.Mailer.Schema.Template

  def list_templates(paginate), do: Repo.paginate(Template, paginate)

  def list_template_by_service(service, paginate) do
    Template
    |> TemplateQuery.by_service(service)
    |> Repo.paginate(paginate)
  end

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

  def template(name)do
    Template
    |> TemplateQuery.by_name(name)
    |> Repo.one()
    |> case do
         nil -> {:error, Error.new("mailer.template.not_found", metadata: [name: name])}
         template -> {:ok, template}
       end
  end
end
