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

defmodule Calculator do
  @eq_regexes [
    {"*", ~r/(\d+)(\*)(\d+)/},
    {"/", ~r/(\d+)(\/)(\d+)/},
    {"+", ~r/(\d+)(\+)(\d+)/},
    {"-", ~r/(\d+)(\-)(\d+)/}
  ]

  @inner_parens_regex ~r/\(([^()]+)\)/

  def calculate(equation) do
    "(#{equation})"
    |> String.replace(" ", "")
    |> solve(:match)
  end

  defp solve(equation, :no_match), do: equation
  defp solve(equation, :match), do: solve(compute_chunk(equation), _match?(@inner_parens_regex, equation))

  defp solve_chunk(chunk, :done), do: chunk
  defp solve_chunk(chunk, :start), do: solve_chunk(chunk, "*", :continue)
  defp solve_chunk(chunk, op, :continue), do: solve_chunk(chunk, op, _match?(@eq_regexes[op], chunk))
  defp solve_chunk(chunk, op,  :match), do: solve_chunk(compute_eq(chunk, op), op, :continue)
  defp solve_chunk(chunk, "*", :no_match), do: solve_chunk(chunk, "/", :continue)
  defp solve_chunk(chunk, "/", :no_match), do: solve_chunk(chunk, "+", :continue)
  defp solve_chunk(chunk, "+", :no_match), do: solve_chunk(chunk, "-", :continue)
  defp solve_chunk(chunk, "-", :no_match), do: solve_chunk(chunk, :done)

  defp compute_chunk(equation) do
    Regex.replace(@inner_parens_regex, equation, fn _, chunk ->
      solve_chunk(chunk, :start)
    end)
  end

  defp compute_eq(chunk, op) do
    Regex.replace(@eq_regexes[op], chunk, fn _, l, op, r ->
      "#{compute({to_int(l), op, to_int(r)})}"
    end)
  end

  defp compute({left, "*", right}), do: left * right
  defp compute({left, "/", right}), do: div(left, right)
  defp compute({left, "+", right}), do: left + right
  defp compute({left, "-", right}), do: left - right

  defp _match?(regex, chunk) do
    case Regex.match?(regex, chunk) do
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
