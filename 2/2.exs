defmodule Part2 do
  def decode_line(line) do
    [_ | draws] = String.split(line, [";", ":"])
    Enum.map(draws, fn draw -> 
      Regex.scan(~r/(\d+)\s*(blue|green|red)/, draw)
      |> Enum.reduce(%{}, fn [_, number, color], acc ->
        Map.put(acc, color, String.to_integer(number))
      end)
    end)
    |> Enum.reduce(%{}, &Map.merge(&1, &2, fn _k1, v1, v2 ->
                          max(v1, v2)
                        end))
    |> Map.values
    |> Enum.reduce(1, &(&1 * &2))
  end

  def decode_file(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> decode_line
    end)
    |> Enum.sum
  end
end


defmodule Part1 do
   @inventory %{
    "red" => 12, "green" => 13, "blue" => 14,
  }

  def decode_line(line) do
    [game | draws] = String.split(line, [";", ":"])
    [_, game_id] = Regex.run(~r/Game (\d+)/, game)
    valid = Enum.map(draws, fn draw -> 
               Regex.scan(~r/(\d+)\s*(blue|green|red)/, draw)
               |> Enum.reduce(true, fn [_, number, color], acc ->
                 acc and (Map.fetch!(@inventory, color) >= String.to_integer(number))
               end)
             end)
             |> Enum.all?
    case valid do
      true ->
        String.to_integer(game_id)
      false -> 
        0
    end
  end

  def decode_file(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> decode_line
    end)
    |> Enum.sum
  end
end


part1 = Part1.decode_file("input.txt")
IO.puts("Part 1: #{part1}")
part2 = Part2.decode_file("input.txt")
IO.puts("Part 2: #{part2}")
