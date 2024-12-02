defmodule App do
  def empty(list) do length(list) === 0 end

  def count_safe_reports(reports) do
    if empty(reports) do 0 
    else
      report = hd(reports)
      count = count_safe_reports(tl(reports))
      #IO.puts("#{count}")
      if is_report_safe(report) do 
        count + 1 
      else 
        count 
      end
    end
  end

  def is_report_safe(report) do
    levels = String.split(report)
    if length(levels) < 2 do false
    else
      #IO.puts("Report levels: #{levels}")
      head = elem(Integer.parse(hd(levels)), 0)
      next = elem(Integer.parse(hd(tl(levels))), 0)
      increasing = head < next
      are_report_levels_safe(head, tl(levels), increasing)
    end
  end

  def are_report_levels_safe(head, tail, increasing) do
    if empty(tail) do true
    else
      next = elem(Integer.parse(hd(tail)), 0)
      if head == next || (increasing && head > next) || (!increasing && head < next) do 
        #IO.puts("NOK: Ordering")
        false
      else
        change = Kernel.abs(head - next)
        if change > 3 do 
          #IO.puts("NOK: Too much changesOrdering")
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

