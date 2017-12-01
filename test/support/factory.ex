defmodule StrawHat.Mailer.Test.Factory do
  use ExMachina.Ecto, repo: StrawHat.Mailer.Repo

  alias StrawHat.Mailer.Schema.{Template}

  def template_factory do
    privacy =
      StrawHat.Mailer.Template.Privacy.values()
      |> Enum.take_random(1)
      |> List.first()

    %Template{
      name: Faker.Pokemon.name(),
      title: Faker.Name.title(),
      owner_id: Faker.String.base64(),
      privacy: privacy,
      subject: "Milka Suberast",
      html_body:
        "Welcome {{name}}, enjoy a good reputation <br> <b>Become </b> our client number <i>{{number}}</i>, enjoy the service."
    }
  end
end
