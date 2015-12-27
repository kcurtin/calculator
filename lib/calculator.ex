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

# Find inner most parens
# Slice from starting parent to ending paren
# Split on operator for mdas
# Calculate
# replace paren range with return val
# Repeat
defmodule Calculator do
  require IEx

  def calculate(string) do
    string |> format_string |> create_equation #|> compute
  end

  def format_string(string), do: String.replace(string, " ", "")

  def create_equation(string) do
    equation_format = ~r/(\d+)(\*|\/|\+|\-)(\d+)/

    str = Regex.replace(equation_format, string, fn _,l,o,r ->
      res = compute {to_int(l), o, to_int(r)}
      "#{res}"
    end)

    if Regex.match?(equation_format, str) do
      create_equation(str)
    else
      str
    end
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
