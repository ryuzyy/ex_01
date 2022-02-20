defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generationg a
  table of the last _n_ issues in a github project
  """
  def run(argv) do
    argv
    |> parse_argv()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name and (oprionally)
  the number of entries to format.
  Return a tuple of`{user, project, count}`, or `help` if help was given.
  """
  def parse_argv(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, count |> String.to_integer()}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  # 不正な引数、または --help の場合
  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process([user, project, _count]) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
  end

  def decode_response([:ok, body]),  do: body
  def decode_response([:error, error]) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end
end
