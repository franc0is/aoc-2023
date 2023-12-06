defmodule MapEntry do
  defstruct source: 0, dest: 0, span: 0

  def from_numbers(numbers) do
    %MapEntry{
      dest: Enum.at(numbers, 0),
      source: Enum.at(numbers, 1),
      span: Enum.at(numbers, 2)
    }
  end
end

defmodule Day5 do
  @digits ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

  def numbers_from_line(line) do
    Regex.scan(~r/\b\d+\b/, line)
    |> List.flatten
    |> Enum.map(&String.to_integer(&1))
  end

  def map_entries_from_lines(lines) do
    lines
    |> Enum.reduce({%{}, 0}, fn line, {entries, index} ->
      case String.at(line, 0) do
        "\n" ->
          {entries, index + 1}
        digit when digit in @digits ->
          entry = line
                  |> numbers_from_line
                  |> MapEntry.from_numbers
          new_values = [entry] ++ Map.get(entries, index, [])
          {Map.put(entries, index, new_values), index}
        _ ->
          {entries, index}
      end
    end)
  end

  #def merge_map_entries(map_entries) do
  #  map_entries
  #  |> Enum.reduce([], fn entry ->

  #  end)
  #end

  def location_from_seed(seed, map_entries) do
    map_entries
    |> Enum.reduce(seed, fn map, source -> 
      x = map
          |> Enum.reduce_while(source, fn map_entry, source ->
            if map_entry.source <= source and (map_entry.source + map_entry.span - 1) >= source do
              dest = map_entry.dest + (source - map_entry.source)
              { :halt, dest }
            else 
              { :cont, source }
            end
          end)
      x
    end)
  end

  def part1(filename) do
    [first | lines] = File.stream!(filename)
                      |> Enum.to_list

    seeds = first
            |> numbers_from_line


    {map_entries, _} = lines
                       |> map_entries_from_lines

    map_entries = map_entries
                  |> Map.values

    seeds
    |> Enum.map(fn seed ->
      location_from_seed(seed, map_entries)
    end)
    |> Enum.min
  end

  def part2(filename) do
    [first | lines] = File.stream!(filename)
                      |> Enum.to_list

    seeds = first
            |> numbers_from_line
            |> Enum.chunk_every(2)
            |> Enum.map(fn [a, b] -> Enum.to_list(a..(a+b-1)) end)
            |> List.flatten

    {map_entries, _} = lines
                       |> map_entries_from_lines

    map_entries = map_entries
                  |> Map.values
                  |> Enum.map(&Enum.reverse(&1))

    seeds
    |> Task.async_stream(fn seed -> location_from_seed(seed, map_entries) end, max_concurrency: 8)
    |> Enum.map(fn {:ok, result} -> result end)
    #|> Enum.map(fn seed ->
    #  location_from_seed(seed, map_entries)
    #end)
    |> Enum.min
  end


end

part1 = Day5.part1('input.txt')
IO.puts("Part 1: #{part1}")

part2 = Day5.part2('input.txt')
IO.puts("Part 2: #{part2}")
