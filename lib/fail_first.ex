defmodule FailFirst do
  defstruct [:pid, :ok, :error]

  def new(count, ok \\ {:ok, :result}, error \\ {:error, :reason}) when count >= 0 do
    {:ok, pid} = Agent.start_link(fn -> count end)
    %__MODULE__{pid: pid, ok: ok, error: error}
  end

  def clone(%__MODULE__{pid: pid, ok: ok, error: error}) do
    count = Agent.get(pid, & &1)
    new(count, ok, error)
  end

  def attempt(%__MODULE__{pid: pid, ok: ok, error: error}) do
    if Agent.get_and_update(pid, &attempt_update/1) == 0 do
      ok
    else
      error
    end
  end

  defp attempt_update(0), do: {0, 0}
  defp attempt_update(x), do: {x, x - 1}

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(fail_first, opts) do
      count = Agent.get(fail_first.pid, & &1)

      concat([
        "#FailFirst<",
        glue(string("left:"), to_doc(count, opts)),
        break(),
        glue(string("ok:"), to_doc(fail_first.ok, opts)),
        break(),
        glue(string("error:"), to_doc(fail_first.error, opts)),
        ">"
      ])
    end
  end
end
