defmodule CalculatorTest do
  use ExUnit.Case
  doctest Calculator

  test "simple addition" do
    assert Calculator.calculate("10 + 100") == "110"
  end

  test "many addition operations" do
    assert Calculator.calculate("2 + 2 + 2 + 2") == "8"
  end

  test "simple subtraction" do
    assert Calculator.calculate("50 - 1") == "49"
  end

  test "many subtraction" do
    assert Calculator.calculate("50 - 1 - 1") == "48"
  end

  test "simple multiplication" do
    assert Calculator.calculate("12 * 4") == "48"
  end

  test "many multiplication" do
    assert Calculator.calculate("10 * 4 * 2") == "80"
  end

  test "simple division" do
    assert Calculator.calculate("12 / 4") == "3"
  end

  test "many division" do
    assert Calculator.calculate("20 / 2 / 2") == "5"
  end

  test "multi before division" do
    assert Calculator.calculate("24 / 2 * 2 * 2") == "3"
  end

  test "division before addition" do
    assert Calculator.calculate("12 + 12 / 2 / 2") == "15"
  end

  test "order of ops with parens" do
    assert Calculator.calculate("(12 + 12) * 2") == "48"
  end

  test "complicated order of ops with parens" do
    assert Calculator.calculate("(12 + 12 + (3 - 2)) * 2 / (5 + 5)") == "5"
  end
end
