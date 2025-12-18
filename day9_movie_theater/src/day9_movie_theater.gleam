import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/pair
import gleam/result
import parser

pub type PositionError {
  NotTwoPositionsError
  UnevenNumberOfPositions
}

pub type AreaRange {
  AreaRange(
    start: parser.Position,
    end: parser.Position,
    bottom: parser.Position,
  )
}

pub type Area {
  Area(top_left: parser.Position, bottom_right: parser.Position)
}

pub fn main() -> Nil {
  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(positions) -> {
          let assert Ok(max_area) =
            solve_part1(positions) |> result.map(int.to_string)
          io.println("Max area part 1: " <> max_area)

          let assert Ok(max_area) =
            solve_part2(positions) |> result.map(int.to_string)
          io.println("Max area part 2: " <> max_area)
        }
        Error(error) -> io.println(parser.error_message(error))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

pub fn solve_part1(
  positions: List(parser.Position),
) -> Result(Int, PositionError) {
  positions
  |> list.combination_pairs
  |> list.map(fn(p) { area(pair.first(p), pair.second(p)) })
  |> list.max(int.compare)
  |> result.replace_error(NotTwoPositionsError)
}

pub fn solve_part2(
  positions: List(parser.Position),
) -> Result(Int, PositionError) {
  positions
  |> list.sort(compare_positions)
  |> list.sized_chunk(2)
  |> list.try_map(fn(line) {
    case line {
      [start, end] -> Ok(AreaRange(start, end, end))
      _ -> Error(UnevenNumberOfPositions)
    }
  })
  |> result.try(handle_events)
  todo
}

/// Find largest areas
pub fn handle_events(
  events: List(AreaRange),
) -> Result(List(#(parser.Position, parser.Position)), PositionError) {
  echo events as "EVENTS"

  events
  |> list.fold_until(Ok([], []), fn(acc, event) {
    let assert Ok(ranges, areas) = ranges
    let new_ranges = update_ranges(event, ranges)
  })
  todo
}

pub fn update_ranges(
  new_range: AreaRange,
  ranges: List(AreaRange),
) -> #(List(AreaRange), List(Area)) {
  ranges
  |> list.fold(#([], []), fn(acc, range) {
    let #(acc_ranges, areas) = acc
    case new_range, range {
      AreaRange(new_start, new_end, _new_bottom), AreaRange(start, end, _bottom)
        if new_start.x > end.x || new_end.x < start.x
      -> #(
        list.append(acc_ranges, [
          new_range,
          range,
        ]),
        areas,
      )
      AreaRange(new_start, new_end, _new_bottom), AreaRange(start, end, _bottom)
        if new_start.x >= start.x && new_end.x <= end.x
      -> #(
        list.append(acc_ranges, [
          AreaRange(min_x(new_start, start), max_x(new_end, end), new_end),
        ]),
        areas,
      )
      AreaRange(new_start, new_end, new_bottom), AreaRange(start, end, bottom) -> #(
        list.prepend(
          acc_ranges,
          AreaRange(min_x(new_start, start), max_x(new_end, end), new_end),
        ),
        [],
      )
    }
  })
}

pub fn max_x(a: parser.Position, b: parser.Position) -> parser.Position {
  case a, b {
    a, b if a.x >= b.x -> a
    _a, b -> b
  }
}

pub fn min_x(a: parser.Position, b: parser.Position) -> parser.Position {
  case a, b {
    a, b if a.x <= b.x -> a
    _a, b -> b
  }
}

pub fn area(p1: parser.Position, p2: parser.Position) -> Int {
  int.add(int.absolute_value(p1.x - p2.x), 1)
  * int.add(int.absolute_value(p1.y - p2.y), 1)
}

pub fn compare_positions(a: parser.Position, b: parser.Position) -> order.Order {
  case int.compare(a.y, b.y) {
    order.Gt -> order.Lt
    order.Lt -> order.Gt
    order.Eq -> int.compare(a.x, b.x)
  }
}
