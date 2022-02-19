defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [ parse_argv: 1]
  test "help returnes by oprion parsing with -h and --help options" do
    assert parse_argv(["-h",     "anything"]) == :help
    assert parse_argv(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_argv(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_argv(["user", "project"]) == { "user", "project", 4}
  end
end
