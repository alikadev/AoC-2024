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

  def get_valid_updates(updates, rules) do
    if length(updates) === 0 do [] else
      nexts = get_valid_updates(tl(updates), rules)
      pages = String.split(hd(updates), ",")
      if is_pages_ordering_valid(pages, rules) do
        #IO.inspect(pages, label: "OK")
        [pages] ++ nexts
      else
        #IO.inspect(pages, label: "KO")
        nexts
      end
    end
  end

  def is_pages_ordering_valid(pages, rules) do
    if length(pages) < 2 do true else 
      page = hd(pages)
      nexts = tl(pages)
      page_rules = Map.get(rules, page)
      #IO.inspect(page_rules, label: "PG rules")
      if !page_rules do 
        #IO.puts("no rules for #{page}");
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
#IO.inspect(rules, label: "Rules")
updates = Enum.filter(String.split(sec_updates, "\n"), fn x -> x !== "" end)
valid_updates = App.get_valid_updates(updates, rules)

get_middle = fn x -> elem(Integer.parse(Enum.at(x, div(length(x),2))), 0) end
sum = Enum.sum(Enum.map(valid_updates, get_middle))
IO.puts("Result: #{sum}")

