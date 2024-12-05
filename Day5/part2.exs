defmodule App do
  def decode_rules(defs) do
    if length(defs) === 0 do Map.new() else
      rules = decode_rules(tl(defs))
      [before, page] = String.split(hd(defs), "|")
      if Map.has_key?(rules, page) do 
        Map.put(rules, page, Map.get(rules, page) ++ [before])
      else
        Map.put(rules, page, [before])
      end
    end
  end

  def get_invalid_updates(updates, rules) do
    if length(updates) === 0 do [] else
      nexts = get_invalid_updates(tl(updates), rules)
      pages = String.split(hd(updates), ",")
      if is_pages_ordering_valid(pages, rules) do nexts
      else
        corrected = correct_pages_ordering(pages, rules)
        [corrected] ++ nexts 
      end
    end
  end

  def correct_pages_ordering(pages, rules) do
    if is_pages_ordering_valid(pages, rules) do pages else
      check_and_permute(pages, 1, rules)
    end
  end

  def check_and_permute(pages, id, rules) do
    if length(pages) + 1 === id do pages else
      before_and_current = elem(Enum.split(pages, id), 0)
      if is_pages_ordering_valid(before_and_current, rules) do
        check_and_permute(pages, id + 1, rules)
      else
        new = swap(pages, id - 1, id - 2)
        check_and_permute(new, id - 1, rules)
      end
    end
  end

  def swap(a, i1, i2) do
    e1 = Enum.at(a, i1)
    e2 = Enum.at(a, i2)
    a
    |> List.replace_at(i1, e2)
    |> List.replace_at(i2, e1)
  end

  def is_pages_ordering_valid(pages, rules) do
    if length(pages) < 2 do true else 
      page = hd(pages)
      nexts = tl(pages)
      page_rules = Map.get(rules, page)
      if !page_rules do 
        is_pages_ordering_valid(nexts, rules)
      else
        apply = fn x -> if Enum.member?(page_rules, x), do: 1, else: 0 end
        if Enum.sum(Enum.map(nexts, apply)) !== 0 do false else
          is_pages_ordering_valid(nexts, rules)
        end
      end
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

[sec_rules, sec_updates] = String.split(input, "\n\n")
rules = App.decode_rules(String.split(sec_rules, "\n"))
updates = Enum.filter(String.split(sec_updates, "\n"), fn x -> x !== "" end)
invalid_updates = App.get_invalid_updates(updates, rules)

get_middle = fn x -> elem(Integer.parse(Enum.at(x, div(length(x),2))), 0) end
sum = Enum.sum(Enum.map(invalid_updates, get_middle))
IO.puts("Result: #{sum}")

