defmodule StrawHat.Mailer.Template.Privacy do
  @moduledoc """
  The privacy of the Template. You could share your templates with others
  based on the privacy.
  """

  use Exnumerator, values: ["private", "public"]

  @typedoc """
  Allowed Values

  - ***private:*** only the owner have access to the template.
  - ***public:*** everyone have access to the template.
  """
  @type t :: String.t
end
