defmodule Calculator.CLI do
  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts "No args given"
  end

  def process(options) do
    Calculator.calculate options[:c]
  end

  def parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [calculate: :string],
      aliases: [c: :string]
    )

    options
  end
end

# Start from inner most parens
# Replace paren range with calc
# Move out a level of parens
# Repeate

defmodule Calculator do
  @regexes [
    {"*", ~r/(\d+)(\*)(\d+)/},
    {"/", ~r/(\d+)(\/)(\d+)/},
    {"+", ~r/(\d+)(\+)(\d+)/},
    {"-", ~r/(\d+)(\-)(\d+)/}
  ]

  def calculate(equation) do
    "(#{equation})"
    |> String.replace(" ", "")
    |> solve(:continue)
  end

  defp solve(equation, :done), do: equation

  defp solve(equation, :continue) do
    inner_parens_regex = ~r/\(([^()]+)\)/

    if Regex.match?(inner_parens_regex, equation) do
      str = Regex.replace(inner_parens_regex, equation, fn _, chunk ->
        solve_chunk(chunk, :start)
      end)
      solve(str, :continue)
    else
      solve(equation, :done)
    end
  end

  defp solve_chunk(chunk, :done),         do: solve(chunk, :continue)
  defp solve_chunk(chunk, :start),        do: solve_chunk(chunk, "*", :continue)
  defp solve_chunk(chunk, op, :continue), do: solve_chunk(chunk, op, _match?(op, chunk))

  defp solve_chunk(chunk, op,  :match),    do: solve_chunk(compute_eq(chunk, op), op, :continue)
  defp solve_chunk(chunk, "*", :no_match), do: solve_chunk(chunk, "/", :continue)
  defp solve_chunk(chunk, "/", :no_match), do: solve_chunk(chunk, "+", :continue)
  defp solve_chunk(chunk, "+", :no_match), do: solve_chunk(chunk, "-", :continue)
  defp solve_chunk(chunk, "-", :no_match), do: solve_chunk(chunk, :done)

  defp compute_eq(chunk, op) do
    Regex.replace(@regexes[op], chunk, fn _, l, op, r ->
      "#{compute({to_int(l), op, to_int(r)})}"
    end)
  end

  defp compute({left, "*", right}), do: left * right
  defp compute({left, "/", right}), do: div(left, right)
  defp compute({left, "+", right}), do: left + right
  defp compute({left, "-", right}), do: left - right

  defp _match?(op, hunk) do
    case Regex.match?(@regexes[op], hunk) do
      true -> :match
      false -> :no_match
    end
  end

  defp to_int str do
    case Integer.parse(str) do
      {int, _ } -> int
    end
  end
end
