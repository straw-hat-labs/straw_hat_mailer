defmodule StrawHat.Mailer.Test.Factory do
  use ExMachina.Ecto, repo: StrawHat.Mailer.Repo

  alias StrawHat.Mailer.Schema.{Template, Partial, Privacy}

  def template_factory do
    privacy = get_privacy()

    %Template{
      name: Faker.Pokemon.name(),
      title: Faker.Name.title(),
      owner_id: Faker.String.base64(),
      privacy: privacy,
      subject: "Milka Suberast",
      pre_header: "Behold then sings my soul",
      html:
        "Welcome {{data.username}}!, <br> <b>Become </b> our client number <i>{{data.number}}</i>",
      text: "Text with name, plain and my number is {{data.number}}"
    }
  end

  def partial_factory do
    privacy = get_privacy()

    %Partial{
      name: Faker.Name.first_name(),
      html: "<b>Located in:</b> {{data.address}}",
      text: "Located in: {{data.address}}",
      privacy: privacy,
      owner_id: Faker.String.base64()
    }
  end

  defp get_privacy() do
    Privacy.values()
    |> Enum.take_random(1)
    |> List.first()
  end
end
