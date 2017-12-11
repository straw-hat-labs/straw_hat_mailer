defmodule StrawHat.Mailer.Test.Factory do
  use ExMachina.Ecto, repo: StrawHat.Mailer.Repo

  alias StrawHat.Mailer.Schema.{Template, Partial}

  def template_factory do
    privacy = get_privacy()

    %Template{
      name: Faker.Pokemon.name(),
      title: Faker.Name.title(),
      owner_id: Faker.String.base64(),
      privacy: privacy,
      subject: "Milka Suberast",
      pre_header: "Behold then sings my soul",
      html_body: "Welcome {{data.username}}!, <br> <b>Become </b> our client number <i>{{data.number}}</i>",
      text_body: "Text with name, plain and my number is {{data.number}}"}
  end

  def partial_factory do
    privacy = get_privacy()

    %Partial{
      key: Faker.String.base64(),
      html: "<b>Located in:</b> {{data.address}}",
      text: "Located in: {{data.address}}",
      privacy: privacy,
      owner_id: Faker.String.base64()}
  end

  defp get_privacy() do
    StrawHat.Mailer.Template.Privacy.values()
    |> Enum.take_random(1)
    |> List.first()
  end
end
