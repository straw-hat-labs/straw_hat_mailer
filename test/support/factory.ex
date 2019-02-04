defmodule StrawHat.Mailer.Test.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: StrawHat.Mailer.TestSupport.Repo

  alias StrawHat.Mailer.{Template, Privacy, Partial}

  def template_factory do
    privacy = get_privacy()

    %Template{
      name: Faker.Pokemon.name(),
      title: Faker.Name.title(),
      owner_id: Faker.String.base64(),
      privacy: privacy,
      subject: Faker.Lorem.sentence(),
      pre_header: "Behold then sings my soul",
      html:
        "Welcome {{data.username}}!, <br> <b>Become </b> our client number <i>{{data.number}}</i>",
      text: "Text with name, plain and my number is {{data.number}}"
    }
  end

  def partial_factory do
    privacy = get_privacy()

    %Partial{
      title: Faker.Lorem.sentence(),
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
