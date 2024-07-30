# FailFirst

Fails for specified amount of times.

## Usage

```elixir
f = FailFirst.new(3, {:ok, :result}, {:error, :reason})
{:error, :reason} = FailFirst.attempt(f)
{:error, :reason} = FailFirst.attempt(f)
{:error, :reason} = FailFirst.attempt(f)
{:ok, :result} = FailFirst.attempt(f)
{:ok, :result} = FailFirst.attempt(f)
```
