{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = StrawHat.Mailer.TestSupport.Repo.start_link()

ExUnit.start()
