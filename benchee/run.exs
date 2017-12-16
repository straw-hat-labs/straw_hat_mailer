
#
# Declared used params or variable:
#
to = "acme@acme.com"
from = "siupport@myapp.com"
data = %{
  name: "jristo",
  number: "1 000 000",
  company: "Straw-hat",
  address: "POBOX 54634",
  username: "tokarev"
}

#
# This function allow generate string key with [length] characters:
#
generate_key = fn length ->
  length
  |> :crypto.strong_rand_bytes()
  |> Base.encode64(padding: false)
  |> String.upcase()
end

#
# This function allow generate [n] partials:
#
generate_partials = fn n -> for _ <- 1..n, do:
  %StrawHat.Mailer.Schema.Partial{
    key: generate_key.(4),
    html: "Welcome {{data.username}}!, <br> <b>Become </b> our client number <i>{{data.number}}</i> <b>Located in:</b> {{data.address}}",
    text: "{{data.username}} {{data.number}} {{data.company}} {{data.name}} Located in: {{data.address}}",
    privacy: "PUBLIC",
    owner_id: "benchee:provider:345098"}
end

#
# Generate dinamic partials key for add to html and text body:
#
generate_dinamic_partials_key = fn partials ->
  partials
  |> Enum.map(fn(%{key: key}) -> "{{partials.#{key}}}" end)
  |> Enum.join(" \n ")
end

#
# Generate one template with [n] partials:
#
generate_template = fn n ->
  partials = generate_partials.(n)
  dinamic_partial_keys = generate_dinamic_partials_key.(partials)
  #
  # Declared template schema with partial schema:
  #
  %StrawHat.Mailer.Schema.Template{
    name: "Benchee",
    title: "Benchee test",
    owner_id: "benchee:provider:345098",
    privacy: "PUBLIC",
    subject: "Milka Suberast",
    pre_header: "Behold then sings my soul",
    html_body: "Welcome {{data.username}}!, <br> <b>Become </b> our client number <i>{{data.number}}</i> #{dinamic_partial_keys}",
    text_body: "Welcome {{data.username}}!, \n Become our client number {{data.number}} #{dinamic_partial_keys}",
    partials: partials
  }
end

#
# Benchmarking the jobs with different inputs
#
inputs = %{
  "Small (3 Partials)"   => generate_template.(3),
  "Middle (10 Partials)" => generate_template.(10),
  "Big (20 Partials)"    => generate_template.(20),
}

#
# Run the Benchmark
#
Benchee.run(%{
  "make_email" => fn template ->
      from
      |> StrawHat.Mailer.Email.new(to)
      |> StrawHat.Mailer.Email.with_template(template, data)
    end
  },
  time: 1,
  print: [fast_warning: false],
  inputs: inputs,
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ])
