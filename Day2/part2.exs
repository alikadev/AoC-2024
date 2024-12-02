defmodule App do
  def empty(list) do length(list) === 0 end

  def count_safe_reports(reports) do
    if empty(reports) do 0 
    else
      report = hd(reports)
      count = count_safe_reports(tl(reports))
      if is_report_safe(String.split(report)) do 
        IO.puts("  >> Success")
        count + 1 
      else 
        IO.puts("  >> Failure")
        count 
      end
    end
  end

  def is_report_safe(levels) do 
    IO.inspect(levels, label: "Report's levels")
    is_report_safe(levels, -1)
  end

  def is_report_safe(levels, iter) do
    if length(levels) < 3 || length(levels) <= iter do false
    else
      levelsD = if iter === -1 do levels else List.delete_at(levels, iter) end
      IO.inspect(levelsD, label: "  Trying #{iter}")
      head = elem(Integer.parse(hd(levelsD)), 0)
      next = elem(Integer.parse(hd(tl(levelsD))), 0)
      result = are_report_levels_safe(head, tl(levelsD), head < next)
      if result do result else 
        is_report_safe(levels, iter+1) 
      end
    end
  end

  def are_report_levels_safe(head, tail, increasing) do
    if empty(tail) do true
    else
      next = elem(Integer.parse(hd(tail)), 0)
      if head == next || (increasing && head > next) || (!increasing && head < next) do 
        IO.puts("  NOK: Ordering in #{head}H .. #{next}N")
        false
      else
        change = Kernel.abs(head - next)
        if change > 3 do 
          IO.puts("  NOK: OverStepping in #{head}H .. #{next}N")
          false
        else 
          are_report_levels_safe(next, tl(tail), increasing)
        end
      end
    end
  end
end

if length(System.argv()) !== 1 do
  raise RuntimeError, message: "Expected input file as arguement"
end

filename = System.argv()

{result, data} = File.read(filename)
if result === :error do
  raise RuntimeError, message: "Failed to open file: #{data}"
end

reports = String.split(data, "\n")
sum = App.count_safe_reports(reports)
IO.puts(sum)

