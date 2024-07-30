# FailFirst

Fails for specified amount of times.

## Usage

```elixir
Mix.install [{:fail_first, git: "https://github.com/yunmikun2/ex_fail_first.git", ref: "master"}]

f = FailFirst.new(3, {:ok, :result}, {:error, :reason})

{:error, :reason} = FailFirst.attempt(f)
{:error, :reason} = FailFirst.attempt(f)
{:error, :reason} = FailFirst.attempt(f)
{:ok, :result} = FailFirst.attempt(f)
{:ok, :result} = FailFirst.attempt(f)
```
