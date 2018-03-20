defmodule StrawHat.Mailer.TemplateEngine do
  @moduledoc false

  alias StrawHat.Mailer.Template

  @callback render(String.t(), data :: map()) :: String.t()

  @since "1.0.0"
  @spec render(%Template{}, any) :: String.t()
  def render(template, data) do
    template_engine().render(template, data)
  end

  @since "1.0.0"
  @spec template_engine :: any
  defp template_engine do
    Application.get_env(
      :straw_hat_mailer,
      :template_engine,
      StrawHat.Mailer.TemplateEngine.BBMustache
    )
  end
end
