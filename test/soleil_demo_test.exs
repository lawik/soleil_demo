defmodule SoleilDemoTest do
  use ExUnit.Case
  doctest SoleilDemo

  test "greets the world" do
    assert SoleilDemo.hello() == :world
  end
end
