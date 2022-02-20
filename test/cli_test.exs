defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_argv: 1, sort_into_descending_order: 1]

  test "help returnes by oprion parsing with -h and --help options" do
    assert parse_argv(["-h", "anything"]) == :help
    assert parse_argv(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_argv(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_argv(["user", "project"]) == {"user", "project", 4}
  end

  test "fetch ryuzyy data" do
    resp = parse_argv(["ryuzyy", "ex_01"])
    require IEx
    IEx.pry()
    assert {"ryuzyy", "ex_01", 4} == resp
  end

  test "sort descending orders the correct way" do
    result = sort_into_descending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  defp fake_created_at_list(values) do
    for value <- values,
        do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
