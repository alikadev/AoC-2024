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
    find_X(lines, 0, 0)
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

  def check_XMAS(lines, position, direction) do
    m_position = direction.(position)
    a_position = direction.(m_position)
    s_position = direction.(a_position)
    if  map_at(lines, m_position) === "M"
    and map_at(lines, a_position) === "A"
    and map_at(lines, s_position) === "S"
    do 1
    else 0 end
  end

  def find_X(lines, x, y) do
    val = map_at(lines, {x, y})
    q = if val !== "X" do 0 else 
      q =     check_XMAS(lines, {x, y}, fn pos -> up(                      pos)  end)
      q = q + check_XMAS(lines, {x, y}, fn pos -> up(right(lines,          pos)) end)
      q = q + check_XMAS(lines, {x, y}, fn pos -> right(lines,             pos)  end)
      q = q + check_XMAS(lines, {x, y}, fn pos -> down(lines, right(lines, pos)) end)
      q = q + check_XMAS(lines, {x, y}, fn pos -> down(lines,              pos)  end)
      q = q + check_XMAS(lines, {x, y}, fn pos -> down(lines, left(        pos)) end)
      q = q + check_XMAS(lines, {x, y}, fn pos -> left(                    pos)  end)
          q + check_XMAS(lines, {x, y}, fn pos -> up(left(                 pos)) end)
    end
    cond do
      x + 1 < map_width(lines)  -> q + find_X(lines, x + 1, y)
      y + 1 < map_height(lines) -> q + find_X(lines, 0, y + 1)
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

