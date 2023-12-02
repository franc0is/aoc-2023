defmodule Part1 do
  def decode_line(line) do
    digits = 
      line
      |> String.graphemes
      |> Enum.filter(fn c ->
        Regex.match?(~r/^\d$/, c)
      end)
    value = List.first(digits) <> List.last(digits)
    #IO.puts("#{line} -> #{value}")
    String.to_integer(value)
  end
  def decode_file(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.replace("\n", "")
      |> decode_line
    end)
  end
end


defmodule Part2 do
  @digit_regex ~r/zero|one|two|three|four|five|six|seven|eight|nine|0|1|2|3|4|5|6|7|8|9/
  @digit_regex_rev ~r/orez|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|0|1|2|3|4|5|6|7|8|9/
  @digit_map %{
    "zero" => "0", "one" => "1", "two" => "2", "three" => "3", "four" => "4",
    "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9"
  }

  def decode_line(line) do
    [first] = 
      Regex.run(@digit_regex, line)
    [last] = 
      Regex.run(@digit_regex_rev, String.reverse(line))
      |> Enum.map(&String.reverse(&1))
    digits =
      [first, last]
      |> Enum.map(fn found -> 
        if String.length(found) > 1 do
          Map.fetch!(@digit_map, found)
        else
          found
        end
      end)
    value = List.first(digits) <> List.last(digits)
    #IO.puts("#{line} -> #{value}")
    String.to_integer(value)
  end

  def decode_file(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.replace("\n", "")
      |> decode_line
    end)
  end
end


part1 = Part1.decode_file("input.txt")
IO.puts("Part 1: #{Enum.sum(part1)}")
part2 = Part2.decode_file("input.txt")
IO.puts("Part 2: #{Enum.sum(part2)}")
