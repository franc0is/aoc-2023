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
      acc + if n in winning_numbers, do: 1, else: 0
    end)
  end

  # Q: How much do I like recursion?
  # A: Quite a lot.
  def process_game_by_index(lut, index) do
    n_matches = Enum.at(lut, index)
    process_matches(n_matches, lut, index, 1)
  end

  defp process_matches(0, _lut, _index, acc), do: acc

  defp process_matches(n_matches, lut, index, acc) do
    new_acc = acc + process_game_by_index(lut, index + n_matches)
    process_matches(n_matches - 1, lut, index, new_acc)
  end

  def part1(file_path) do
    File.stream!(file_path)
    |> Enum.reduce(0, fn line, score ->
      line
      |> String.trim
      |> find_matches
      |> then(&trunc(:math.pow(2, &1 - 1))) # Score game
      |> Kernel.+(score)
    end)
  end

  def part2(file_path) do
    # We cache the number of matches in a LUT
    # Otherwise it's slow
    lut = File.stream!(file_path)
          |> Enum.map(&String.trim/1)
          |> Enum.map(&find_matches/1)

    Enum.with_index(lut)
    |> Enum.reduce(0, fn {_, index}, acc ->
      acc + process_game_by_index(lut, index)
    end)
  end
end


part1 = Day4.part1('input.txt')
IO.puts("Part 1: #{part1}")
part2 = Day4.part2('input.txt')
IO.puts("Part 2: #{part2}")
