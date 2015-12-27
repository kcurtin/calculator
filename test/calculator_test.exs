defmodule CalculatorTest do
  use ExUnit.Case
  doctest Calculator

  test "simple addition" do
    assert Calculator.calculate("10 + 100") == "110"
  end

  test "multiple addition operations" do
    assert Calculator.calculate("2 + 2 + 2") == "6"
  end

  test "simple subtraction" do
    assert Calculator.calculate("50 - 1") == "49"
  end

  test "simple multiplication" do
    assert Calculator.calculate("12 * 4") == "48"
  end

  test "simple division" do
    assert Calculator.calculate("12 / 4") == "3.0"
  end

  test "multi before division" do
    assert Calculator.calculate("12 / 2 * 2") == "3.0"
  end

  test "division before addition" do
    assert Calculator.calculate("12 + 12 / 2") == "18.0"
  end
end
