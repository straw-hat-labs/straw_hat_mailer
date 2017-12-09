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
      html_body: "Welcome, enjoy a good reputation <br> <b>Become </b> our client number <i>{{number}}</i>, enjoy the service.",
      text_body: "Text with name, plain and my number is {{number}}"}
  end

  def partial_factory do
    privacy = get_privacy()

    %Partial{
      key: Faker.String.base64(),
      html: "<b>Located in:</b> {{address}}",
      text: "Located in: {{address}}",
      privacy: privacy,
      owner_id: Faker.String.base64()}
  end

  defp get_privacy() do
    StrawHat.Mailer.Template.Privacy.values()
    |> Enum.take_random(1)
    |> List.first()
  end
end
