defmodule StrawHat.Mailer.Test.Factory do
  use ExMachina.Ecto, repo: StrawHat.Mailer.Repo

  def get_random_string(length \\ 5) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64
  end

  def template_factory do
    %StrawHat.Mailer.Schema.Template{
      name: get_random_string(),
      title: get_random_string(),
      owner_id: "some_service",
      subject: "Milka Suberast",
      text_body: "Welcome {{name}}, enjoy a good reputation",
      html_body: "<b>Become </b> our client number <i>{{number}}</i>, enjoy the service."}
  end
end
