defmodule ThiefTest do
  use ExUnit.Case
  doctest Thief

  test "greets the world" do
    assert Thief.hello() == :world
  end
end
