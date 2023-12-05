defmodule Token do
  defstruct y: -1, x_min: -1, x_max: -1, value: 0

  def adjacent?(t1, t2) do
    (t1.y >= t2.y - 1) and
    (t1.y <= t2.y + 1) and
    (t1.x_min >= t2.x_min - 1) and
    (t1.x_max <= t2.x_max + 1)
  end
end

defmodule Day3 do
  def numbers_from_wip(wip, x, y, numbers) do
    if !Enum.empty?(wip) do
      num = wip
            |> Enum.reverse
            |> Enum.join
            |> String.to_integer
      x_min = x - length(wip) + 1
      [%Token{y: y, x_min: x_min, x_max: x, value: num} | numbers]
    else
      numbers
    end
  end

  def parse_line(line, y, columns) do
    {_, numbers, symbols} =
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce({[], [], []}, fn {g, x}, {wip, numbers, symbols} ->
        if String.match?(g, ~r/^\d$/) do
          # digit
          wip = [g | wip]
          if x >= (columns - 1) do
            {[], numbers_from_wip(wip, x, y, numbers), symbols}
          else
            {wip, numbers, symbols}
          end
        else 
          case g do
            "." ->
              # comma
              {[], numbers_from_wip(wip, x - 1, y, numbers), symbols}
            _ ->
              #symbol
              {[], numbers_from_wip(wip, x - 1, y, numbers), [%Token{y: y, x_min: x, x_max: x, value: g} | symbols]}
          end
        end
      end)
    {numbers, symbols}
  end

  def find_and_add_part_numbers({numbers, symbols}) do
    {n, _} = numbers
             |> Enum.reduce({0, symbols}, fn n, {acc, symbols} -> 
               acc = symbols
                     |> Enum.reduce_while(acc, fn s, acc ->
                       if Token.adjacent?(s, n) do
                         {:halt, acc + n.value}
                       else
                         {:cont, acc}
                       end
                     end)
               {acc, symbols}
             end)
    n
  end

  def find_and_multiply_gears({numbers, symbols}) do
    {n, _} = symbols
    |> Enum.filter(fn s -> s.value == "*" end)
    |> Enum.reduce({0, numbers}, fn s, {acc, numbers} ->
      #IO.inspect(s)
      potential_gears = numbers
                        |> Enum.reduce([], fn n, parts ->
                          if Token.adjacent?(s, n) do
                            [n | parts]
                          else
                            parts
                          end
                        end)
      if length(potential_gears) == 2 do
        {acc + Enum.at(potential_gears, 0).value * Enum.at(potential_gears, 1).value, numbers}
      else
        {acc, numbers}
      end
    end)
    n
  end

  def part2(file_path) do
    file_stream = File.stream!(file_path)
    columns = (file_stream |> Enum.take(1) |> List.first |> String.length) - 1

    file_stream
    |> Enum.with_index
    |> Enum.reduce({[], []}, fn {line, y}, {numbers, symbols} ->
      line = line
             |> String.replace("\n", "")
      {n, s} = parse_line(line, y, columns)
      {numbers ++ n, symbols ++ s}
    end)
    |> find_and_multiply_gears
  end

  def part1(file_path) do
    file_stream = File.stream!(file_path)
    columns = (file_stream |> Enum.take(1) |> List.first |> String.length) - 1

    file_stream
    |> Enum.with_index
    |> Enum.reduce({[], []}, fn {line, y}, {numbers, symbols} ->
      line = line
             |> String.replace("\n", "")
      {n, s} = parse_line(line, y, columns)
      {numbers ++ n, symbols ++ s}
    end)
    |> find_and_add_part_numbers
  end
end


part1 = Day3.part1('input.txt')
IO.puts("Part 1: #{part1}")
part2 = Day3.part2('input.txt')
IO.puts("Part 2: #{part2}")

