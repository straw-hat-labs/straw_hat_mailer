defmodule StrawHat.Mailer.Query.Template do
  import Ecto.Query, only: [from: 2]

  def by_service(query, service) do
    from template in query,
      where: ^[service: service]
  end

  def by_name(query, name) do
    from template in query,
      where: ^[name: name]
  end
end
