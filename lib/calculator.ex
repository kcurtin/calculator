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
  require IEx

  def calculate(equation_string) do
    equation_string
    |> strip_whitespace
    |> solve(~r/(\d+)(\*)(\d+)/)
    |> solve(~r/(\d+)(\/)(\d+)/)
    |> solve(~r/(\d+)(\+)(\d+)/)
    |> solve(~r/(\d+)(\-)(\d+)/)
  end

  def strip_whitespace(equation_string), do: String.replace(equation_string, " ", "")

  def solve(equation_string, equation_regex), do: _solve(equation_string, equation_regex)

  defp _solve(equation_string, equation_regex) do
    str = _replace_equation_with_computation(equation_string, equation_regex)

    cond do
      Regex.match?(equation_regex, str) -> _solve(str, equation_regex)
      str -> str
      nil -> equation_string
    end
  end

  defp _replace_equation_with_computation(equation_string, equation_regex) do
    Regex.replace(equation_regex, equation_string, fn _,l,o,r ->
      "#{_compute {_to_int(l), o, _to_int(r)}}"
    end)
  end

  defp _compute({left, "*", right}), do: left * right
  defp _compute({left, "/", right}), do: div(left, right)
  defp _compute({left, "+", right}), do: left + right
  defp _compute({left, "-", right}), do: left - right
  defp _to_int str do
    {int, _ } = Integer.parse(str)
    int
  end
end
