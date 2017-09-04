defmodule App do
  @moduledoc "Some helpers for CLI."

  def restart() do
    Application.stop(:plustwo)
    recompile()
    Application.ensure_all_started(:plustwo)
  end
end
