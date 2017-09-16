defmodule StrawHat.Mailer.Test.Factory do
  use ExMachina.Ecto, repo: StrawHat.Mailer.Repo

  alias StrawHat.Mailer.Schema.{
    Template}

  def template_factory do
    %Template{
      name: Faker.String.base64(),
      title: Faker.Name.title(),
      owner_id: Faker.String.base64(),
      privacy: "private",
      subject: "Milka Suberast",
      text_body: "Welcome {{name}}, enjoy a good reputation",
      html_body: "<b>Become </b> our client number <i>{{number}}</i>, enjoy the service."}
  end
end
