defmodule Day4 do
  def string_to_numbers(str) do
    Regex.scan(~r/\b\d{1,2}\b/, str)
    |> List.flatten
    |> Enum.map(&String.to_integer(&1))
  end

  def find_matches(line) do
    # Discard game number
    [_, numbers] = String.split(line, ":")

    [winning_numbers, numbers_we_have] = 
      numbers
      |> String.split("|")
      |> Enum.map(fn s -> string_to_numbers(s) end)

    numbers_we_have
    |> Enum.reduce(0, fn n, acc ->
      if n in winning_numbers do
        acc + 1 
      else
        acc
      end
    end)
  end

  def part1(file_path) do
    File.stream!(file_path)
    |> Enum.reduce(0, fn line, score ->
      line
      |> String.replace("\n", "")
      |> find_matches
      |> then(fn m -> trunc(:math.pow(2, m - 1)) end) # Score game
      |> then(fn s -> score + s end) # Accumulate score
    end)
  end

  def part2(file_path) do
    :ok
  end
end


part1 = Day4.part1('input.txt')
IO.puts("Part 1: #{part1}")
part2 = Day4.part2('test.txt')
IO.puts("Part 2: #{part2}")
