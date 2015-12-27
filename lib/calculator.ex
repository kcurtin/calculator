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
    equation
    |> String.replace(" ", "")
    |> _solve("*", :continue)
  end

  # inner_parens_regex = ~r/\(([^()]+)\)/
  defp _solve(equation, :done),          do: equation
  defp _solve(equation, op, :continue),  do: _solve(equation, _match?(op, equation), op)
  defp _solve(equation, :match, op),     do: _solve(_compute_eq(equation, op), op, :continue)
  defp _solve(equation, :no_match, "*"), do: _solve(equation, "/", :continue)
  defp _solve(equation, :no_match, "/"), do: _solve(equation, "+", :continue)
  defp _solve(equation, :no_match, "+"), do: _solve(equation, "-", :continue)
  defp _solve(equation, :no_match, "-"), do: _solve(equation, :done)

  defp _compute_eq(equation, op) do
    Regex.replace(@regexes[op], equation, fn _, l, op, r ->
      "#{_compute({_to_int(l), op, _to_int(r)})}"
    end)
  end

  defp _compute({left, "*", right}), do: left * right
  defp _compute({left, "/", right}), do: div(left, right)
  defp _compute({left, "+", right}), do: left + right
  defp _compute({left, "-", right}), do: left - right

  defp _match?(op, equation) do
    case Regex.match?(@regexes[op], equation) do
      true -> :match
      false -> :no_match
    end
  end

  defp _to_int str do
    case Integer.parse(str) do
      {int, _ } -> int
    end
  end
end
