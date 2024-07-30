defmodule FailFirst do
  defstruct [:pid, :total, :ok, :error]

  def new(total, ok \\ {:ok, :result}, error \\ {:error, :reason}) when total >= 0 do
    {:ok, pid} = Agent.start_link(fn -> total end)
    %__MODULE__{pid: pid, total: total, ok: ok, error: error}
  end

  def clone(%__MODULE__{pid: pid, total: total, ok: ok, error: error}) do
    {:ok, pid} = Agent.start_link(fn -> Agent.get(pid, & &1) end)
    %__MODULE__{pid: pid, total: total, ok: ok, error: error}
  end

  def reset(%__MODULE__{pid: pid, total: total}) do
    Agent.update(pid, fn _ -> total end)
  end

  def count(%__MODULE__{pid: pid}) do
    Agent.get(pid, & &1)
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
      concat([
        "#FailFirst<",
        glue(
          to_doc(FailFirst.count(fail_first), opts),
          "/",
          to_doc(fail_first.total, opts)
        ),
        break(),
        glue(string("ok:"), to_doc(fail_first.ok, opts)),
        break(),
        glue(string("error:"), to_doc(fail_first.error, opts)),
        ">"
      ])
    end
  end
end
