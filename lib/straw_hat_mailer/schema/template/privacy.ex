defmodule StrawHat.Mailer.Template.Privacy do
  @moduledoc """
  The privacy of the Template. You could share your templates with others
  chaning the privacy of it.

  Privacies

  - private: only the owner have access to the template
  - public: everyone have access to the template
  """

  use Exnumerator,
      values: [:private, :public]
end
