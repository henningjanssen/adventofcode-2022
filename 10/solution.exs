
defmodule Day10 do
  def handleLine(line) do
    cond do
      line == "noop" -> [0]
      String.match?(line, ~r/^addx -?[[:digit:]]+$/i) -> [0, String.split(line) |> List.last |> String.to_integer]
    end
  end

  def reduce(val, acc) do
    {idx, register, signal} = acc

    # part 2 printing
    screenpos = rem(idx-1, 40)
    cond do
      screenpos >= register - 1 && screenpos <= register + 1 -> IO.write("#")
      true -> IO.write(".")
    end
    if screenpos == 39 do IO.puts("") end
    # /part 2 printing

    newsignal = if rem(idx - 20, 40) == 0 do
        signal + idx * register
      else
        signal
      end
    {idx+1, register+val, newsignal}
  end

  def handleFile(filename) do
    File.stream!(filename, [:trim, :line])
      |> Enum.map(&String.trim(&1))
      |> Enum.flat_map(&Day10.handleLine(&1))
      |> Enum.reduce({1, 1, 0}, fn x, acc -> reduce(x, acc) end)
      |> (fn x -> IO.puts("part 1: " <> Integer.to_string(elem(x, 2))) end).()
  end
end

Day10.handleFile("input.txt")
