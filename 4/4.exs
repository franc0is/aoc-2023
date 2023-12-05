defmodule Day4 do
  def string_to_numbers(str) do
    Regex.scan(~r/\b\d{1,2}\b/, str)
    |> List.flatten
    |> Enum.map(&String.to_integer(&1))
  end

  def score_line(line) do
    # Discard game number
    [_, numbers] = String.split(line, ":")

    [winning_numbers, numbers_we_have] = 
      numbers
      |> String.split("|")
      |> Enum.map(fn s -> string_to_numbers(s) end)

    matches = 
      numbers_we_have
      |> Enum.reduce(0, fn n, acc ->
        if n in winning_numbers do
          acc + 1 
        else
          acc
        end
      end)

    trunc(:math.pow(2, matches - 1))
  end

  def part1(file_path) do
    File.stream!(file_path)
    |> Enum.reduce(0, fn line, score ->
      line
      |> String.replace("\n", "")
      |> score_line
      |> (fn x -> x + score end).() # because can't pipe into +
    end)
  end
end


part1 = Day4.part1('input.txt')
IO.puts("Part 1: #{part1}")
