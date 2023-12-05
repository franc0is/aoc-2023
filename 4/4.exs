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

  # Q: How much do I like recursion?
  # A: Quite a lot.
  def process_game_by_index(lut, index, acc \\ 0) do
    n_matches = lut
                |> Enum.at(index)

    match_list = if n_matches > 0 do Enum.to_list(1..n_matches) else [] end
    process_matches(match_list, lut, index, acc + 1)
  end

  defp process_matches([], _lut, _index, acc), do: acc

  defp process_matches([match | rest], lut, index, acc) do
    new_acc = acc + process_game_by_index(lut, index + match)
    process_matches(rest, lut, index, new_acc)
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
    # We cache the number of matches in a LUT
    # Otherwise it's slow
    lut = File.stream!(file_path)
          |> Enum.map(fn line ->
            line
            |> String.replace("\n", "")
            |> find_matches
          end)

    lut
    |> Enum.with_index
    |> Enum.reduce(0, fn {_, index}, acc ->
      acc + process_game_by_index(lut, index)
    end)
  end
end


part1 = Day4.part1('input.txt')
IO.puts("Part 1: #{part1}")
part2 = Day4.part2('input.txt')
IO.puts("Part 2: #{part2}")
