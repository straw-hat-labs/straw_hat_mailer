defmodule StrawHat.Mailer.Test.Factory do
  use ExMachina.Ecto, repo: StrawHat.Mailer.Repo

  def get_random_string(length \\ 5) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64
  end

  def template_factory do
    %StrawHat.Mailer.Schema.Template{
      name: get_random_string(),
      service: get_random_string(3),
      from: build(:from),
      subject: "Milka Suberast",
      text_body: "Welcome {name}, enjoy a good reputation",
      html_body: "<b>Become </b> our client number <i>{number}</i>, enjoy the service."}
  end

  def from_factory do
    %StrawHat.Mailer.Schema.Template.From{
       name: Faker.Name.name(),
       email: Faker.Internet.email()}
  end
end
