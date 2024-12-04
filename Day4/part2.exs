defmodule App do
  def map_height(lines) do Enum.count(lines) end
  def map_width(lines) do String.length(Enum.at(lines, 0)) end
  def map_at(lines, position) do 
    case position do
      :error -> :error
      {x, y} -> String.at(Enum.at(lines, y), x) 
    end
  end

  def find_XMAS(input) do
    lines = for x when x !== "" <- String.split(input, "\n"), do: x
    find_A(lines, 0, 0)
  end

  def down(lines, position) do 
    case position do
      :error -> :error
      {x, y} -> if y >= map_height(lines) - 1 do :error else {x, y + 1} end
    end
  end 
  def right(lines, position) do 
    case position do
      :error -> :error
      {x, y} -> if x >= map_width(lines) do :error else {x + 1, y} end
    end
  end 
  def up(position) do 
    case position do
      :error -> :error
      {x, y} -> if y <= 0 do :error else {x, y - 1} end
    end
  end 
  def left(position) do 
    case position do
      :error -> :error
      {x, y} -> if x <= 0 do :error else {x - 1, y} end
    end
  end 

  def find_A(lines, x, y) do
    val = map_at(lines, {x, y})
    q = if val !== "A" do 0 else 
      ul = map_at(lines, up(left(                 {x, y})))
      ur = map_at(lines, up(right(lines,          {x, y})))
      dl = map_at(lines, down(lines, left(        {x, y})))
      dr = map_at(lines, down(lines, right(lines, {x, y})))
      cond do
        ur === dl                 -> 0
        ul === dr                 -> 0
        ul !== ur  and ul !== dl  -> 0
        dr !== ur  and dr !== dl  -> 0
        ur === "M" and dl === "S" -> 1
        ur === "S" and dl === "M" -> 1
        true                      -> 0
      end
    end
    cond do
      x + 1 < map_width(lines)  -> q + find_A(lines, x + 1, y)
      y + 1 < map_height(lines) -> q + find_A(lines, 0, y + 1)
      true                      -> q
    end
  end
end

if length(System.argv()) !== 1 do
  raise RuntimeError, message: "Expected input file as argument"
end
filename = System.argv();

{status, input} = File.read(filename)
if status !== :ok do
  raise RuntimeError, message: "Failed to open file: #{input}"
end

result = App.find_XMAS(input)
IO.puts(result)

