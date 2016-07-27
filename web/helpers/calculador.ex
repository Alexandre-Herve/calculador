defmodule Calculador.Operador do
  import Enum
  require IEx
  require Logger

  def calculate(string) do
    string
    |> remove_equal
    |> remove_external_parenthesis
    |> with_parenthesis
  end

  def remove_external_parenthesis(string) do
    surrounded = Regex.match?(~r/\)$/, string) && Regex.match?(~r/^\(/, string)
    if surrounded do
      string
      |> (fn(string) -> Regex.replace(~r/\)$/, string, "") end).()
      |> (fn(string) -> Regex.replace(~r/^\(/, string, "") end).()
    else
      string
    end
  end

  def split_string(string) do
    split = Regex.split(~r/\(([^)(]+)?\)/, string, include_captures: true, trim: true)
    Enum.map(split, fn(s) -> remove_external_parenthesis(s) end)
  end

  def has_parenthesis(string) do
    parenthesis_regex = ~r/[\(\)]/
    Regex.match?(parenthesis_regex, string)
  end

  def is_integer_surrounded(string) do
    Regex.match?(~r/^[0-9].*[0-9]$/, string)
  end

  def ok_to_calculate(string) do
    !has_parenthesis(string) && is_integer_surrounded(string)
  end

  def with_parenthesis(string) do
    # helper
    handle_element = fn(element) ->
      if ok_to_calculate(element) do
        calculate_no_parenthesis(element) |> Integer.to_string()
      else
        element
      end
    end

    # computation
    if has_parenthesis(string) do
      interm = split_string(string)
      |> Enum.map(handle_element)
      |> Enum.join("")
      |> with_parenthesis()
    else
      calculate_no_parenthesis(string)
    end
  end

  defp calculate_no_parenthesis(string) do
    do_add = fn(a, b) -> a + b end
    do_sub = fn(a, b) -> b - a end
    do_mul = fn(a, b) -> a * b end

    add = get_operator({ "+", do_add })
    sub = get_operator({ "-", do_sub })
    mul = get_operator({ "*", do_mul })

    apply_operations(string, [add, sub, mul])
  end

  defp get_operator({ symbol, operation }) do
    fn(string, sub_operator) -> operate string, sub_operator, symbol, operation end
  end

  defp operate(string, sub_operator, symbol, operator) do
    string
    |> String.split(symbol)
    |> map(sub_operator)
    |> reduce(operator)
  end

  defp remove_equal(string) do
    case String.last(string) do
      "=" ->
        length = String.length(string)
        slice_limit = length - 2
        String.slice(string, 0..slice_limit)
      _ ->
        string
    end
  end

  defp apply_operations(string, [h | t]) do
    h.(string, fn(string) -> apply_operations(string, t) end) 
  end

  defp apply_operations(string, []) do
    parse_int(string)
  end

  defp parse_int(string) do
    case Integer.parse(string) do
      {x, _} -> x
      _ -> 0
    end
  end
end
