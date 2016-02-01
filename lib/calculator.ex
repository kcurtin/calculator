defmodule Calculator.CLI do
  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts "No args given"
  end

  def process(options) do
    IO.puts Calculator.calculate options[:c]
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
  @inner_parens_regex ~r/\(([^()]+)\)/

  def calculate(equation) do
    "(#{equation})"
    |> String.replace(" ", "")
    |> solve(:match)
  end

  defp solve(equation, :no_match), do: equation
  defp solve(equation, :match) do
    solve(compute_chunk(equation), _match?(@inner_parens_regex, equation))
  end

  defp solve_chunk(chunk, :done), do: chunk
  defp solve_chunk(chunk, :start), do: solve_chunk(chunk, "*", :continue)
  defp solve_chunk(chunk, op, :continue) do
    solve_chunk(chunk, op, _match?(op_to_regex(op), chunk))
  end
  defp solve_chunk(chunk, op,  :match), do: solve_chunk(compute_eq(chunk, op), op, :continue)
  defp solve_chunk(chunk, "*", :no_match), do: solve_chunk(chunk, "/", :continue)
  defp solve_chunk(chunk, "/", :no_match), do: solve_chunk(chunk, "+", :continue)
  defp solve_chunk(chunk, "+", :no_match), do: solve_chunk(chunk, "-", :continue)
  defp solve_chunk(chunk, "-", :no_match), do: solve_chunk(chunk, :done)

  defp op_to_regex(op) do
    {:ok, regexp} = Regex.compile("(\\d+)(\\#{op})(\\d+)")
    regexp
  end

  defp compute_chunk(equation) do
    Regex.replace(@inner_parens_regex, equation, fn _, chunk ->
      solve_chunk(chunk, :start)
    end)
  end

  defp compute_eq(chunk, op) do
    op_to_regex(op)
    |> Regex.replace(chunk, fn _, l, op, r -> "#{compute({to_int(l), op, to_int(r)})}" end)
  end

  defp compute({left, op, right}) do
    Kernel
    |> apply(String.to_atom(op), [left, right])
    |> round
  end

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
