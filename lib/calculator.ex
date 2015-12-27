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
  require IEx

  # Find inner most parens
  # Slice from starting parent to ending paren

  # Split on operator for mdas
  # Calculate
  # replace paren range with return val
  # Repeat
  def calculate(string) do
    string |> format_string |> create_equation #|> compute
  end

  def format_string(string), do: String.replace(string, " ", "")

  def create_equation(string) do
    equation_format = ~r/(\d+)(\*|\/|\+|\-)(\d+)/

    Regex.replace(equation_format, string, fn _,l,o,r ->
      res = compute {to_int(l), o, to_int(r)}
      "#{res}"
    end)
  end

  def to_int str do
    {int, _ } = Integer.parse(str)
    int
  end

  def compute({left, "*", right}), do: left * right
  def compute({left, "/", right}), do: left / right
  def compute({left, "+", right}), do: left + right
  def compute({left, "-", right}), do: left - right
end
  # def calculate_expression(list) do
  #   operators = [ "*", "/", "+", "-"]
  #
  #   vals = Enum.map(operators, fn(op) -> compute_for(list, op) end)
  #   Enum.filter(vals, fn(x) -> x != nil end)
  # end
  #
  # def compute_for(list, op) do
  #   operator_index = Enum.find_index(list, fn(n) -> n == op end)
  #
  #   if operator_index do
  #     left = Enum.at(list, operator_index - 1)
  #     operator = Enum.at(list, operator_index)
  #     right = Enum.at(list, operator_index + 1)
  #
  #
  #     compute {left, operator, right}
  #   end
  # end
  #
  #   # operator_regex = ~r/\+|\-|\*|\//
  #   # [operator] = Regex.run(operator_regex, string)
  #   #
  #   # [{left, _}, {right, _}] =
  #   #   String.split(string, operator_regex, trim: true)
  #   #     |> Enum.map(&(String.strip(&1)))
  #   #     |> Enum.map(&(Integer.parse(&1)))
  #   #
  #   # compute {left, operator, right}
