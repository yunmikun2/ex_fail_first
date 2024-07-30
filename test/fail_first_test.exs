defmodule FailFirstTest do
  use ExUnit.Case, async: true

  test "returns an error first" do
    f = FailFirst.new(1)
    assert FailFirst.attempt(f) == {:error, :reason}
  end

  test "returns an ok when fails ended" do
    f = FailFirst.new(0)
    assert FailFirst.attempt(f) == {:ok, :result}
  end

  test "continues to return ok" do
    f = FailFirst.new(3)
    assert FailFirst.attempt(f) == {:error, :reason}
    assert FailFirst.attempt(f) == {:error, :reason}
    assert FailFirst.attempt(f) == {:error, :reason}
    assert FailFirst.attempt(f) == {:ok, :result}

    for _ <- 1..100 do
      assert FailFirst.attempt(f) == {:ok, :result}
    end
  end

  test "clones exact state" do
    a = FailFirst.new(3)
    assert FailFirst.attempt(a) == {:error, :reason}
    b = FailFirst.clone(a)
    assert FailFirst.attempt(a) == {:error, :reason}
    assert FailFirst.attempt(a) == {:error, :reason}
    assert FailFirst.attempt(a) == {:ok, :result}

    assert FailFirst.attempt(b) == {:error, :reason}
    assert FailFirst.attempt(b) == {:error, :reason}
    assert FailFirst.attempt(b) == {:ok, :result}
  end
end
