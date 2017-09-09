{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.configure(exclude: [:pending])
ExUnit.configure formatters: [ExUnit.CLIFormatter, ExUnitNotifier]
ExUnit.start()
