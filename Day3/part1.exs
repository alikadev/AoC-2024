defmodule App do
  def compute(input) do
    if String.length(input) < 3 do 0 else
      next = compute(String.slice(input, 1 .. -1//1))
      cond do
        String.starts_with?(input, "mul") 
             -> instr_mul(String.slice(input, 3 .. -1//1)) + next
        true -> next
      end
    end
  end

  def instr_mul(args) do
    case binop(args) do
      :error -> 0
      [a, b] -> a * b
    end
  end

  def binop(args) do
    if String.at(args, 0) !== "(" do :error else
      ops = String.slice(args, 1 .. -1//1)
      res = get_operands(ops, 2)
      if res === :error do :error else
        {xs, rest} = res
        if String.at(rest, 0) !== ")" do :error else xs end
      end
    end
  end

  def get_operands(ops, count) do
    res = Integer.parse(ops)
    if res === :error do :error else
      {val, rem} = res
      if count === 1 do {[val], rem} else
        if String.at(rem, 0) !== "," do :error else
          next = String.slice(rem, 1 .. -1//1)
          case get_operands(next, count - 1) do
            :error    -> :error
            {xs, rem} -> {xs ++ [val], rem}
          end
        end
      end
    end
  end
end

#dbg(App.binop("(12,13)"))
#dbg(App.binop("!12,13)"))
#dbg(App.binop("(12,13!"))
#dbg(App.binop("(!,13)"))
#dbg(App.binop("(12!,13)"))
#dbg(App.binop("(12,1!3)"))

if length(System.argv()) !== 1 do
  raise RuntimeError, message: "Expected input file as argument"
end
filename = System.argv();

{status, code} = File.read(filename)
if status !== :ok do
  raise RuntimeError, message: "Failed to open file: #{code}"
end

result = App.compute(code)
IO.puts(result)

