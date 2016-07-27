defmodule Calculador.OperadorTest do
  use ExUnit.Case
  alias Calculador.Operador

  test "has parenthesis" do
    expr1 = "3+5"
    assert Operador.has_parenthesis(expr1) === false

    expr2 = ")3+5"
    assert Operador.has_parenthesis(expr2) === true

    expr3 = "3+(5"
    assert Operador.has_parenthesis(expr3) === true
  end

  test "ok to calculate" do
    expr1 = "*3+5"
    assert Operador.ok_to_calculate(expr1) === false

    expr2 = "3+5"
    assert Operador.has_parenthesis(expr2) === false
    assert Operador.is_integer_surrounded(expr2) === true
    assert Operador.ok_to_calculate(expr2) === true

    expr3 = "3+(5"
    assert Operador.ok_to_calculate(expr3) === false
  end

  test "removes external parenthesis" do
    stuff = "lol(ho)"
    stuff_w_parenthesis = "(" <> stuff <> ")"
    assert Calculador.Operador.remove_external_parenthesis(stuff_w_parenthesis) === stuff
    assert Calculador.Operador.remove_external_parenthesis(stuff) === stuff
  end

  test "split string" do
    stuff = "(lol(ho))ah(lol)a"
    calculated = Calculador.Operador.split_string(stuff)
    expected = ["(lol", "ho", ")ah", "lol", "a"]
    assert calculated === expected
  end

  test "removes the trailing equal symbol" do
    with_eq = Operador.calculate("1+5=")
    without_eq = Operador.calculate("1+5")
    assert without_eq === with_eq
  end

  test "addition" do
    sum = Operador.calculate("1+5")
    assert sum === 6
  end

  test "subtraction" do
    sum = Operador.calculate("5-1")
    assert sum === 4
  end

  test "multiplication" do
    sum = Operador.calculate("5*7")
    assert sum === 35
  end

  test "precedence of multiplication" do
    sum = Operador.calculate("3-5*7+1")
    assert sum === -31
  end

  test "precedence of parenthesis" do
    sum = Operador.calculate("(3-5)*7+1")
    assert sum === -13
  end

  test "outer parenthesis" do
    sum = Operador.calculate("(5*3-3)")
    assert sum === 12
  end

  test "complex precedence of parenthesis" do
    sum = Operador.calculate("(3-(5*6+2))*2+1")
    assert sum === -57
  end

  test "minus numbers" do
    sum = Operador.calculate("8*(-3)")
    assert sum === -24

    sum = Operador.calculate("8*-3")
    assert sum === -24
  end
end
