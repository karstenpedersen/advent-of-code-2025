import argv
import gleam/int
import gleam/io
import gleam/list
import parser
import range

pub fn main() -> Nil {
  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(#(ranges, ids)) -> {
          let n_fresh_ingredients = solve_part1(ranges, ids) |> int.to_string
          io.println("Fresh ingredients: " <> n_fresh_ingredients)

          let n_total_fresh_ids = solve_part2(ranges) |> int.to_string
          io.println("Total fresh ingredients: " <> n_total_fresh_ids)
        }
        Error(error) -> io.println(parser.error_message(error))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

pub fn solve_part1(ranges: List(range.Range), ids: List(Int)) -> Int {
  ids
  |> list.fold(0, fn(acc, id) {
    let is_inside_a_range = ranges |> list.any(range.is_inside(_, id))
    case is_inside_a_range {
      True -> acc + 1
      False -> acc
    }
  })
}

pub fn solve_part2(ranges: List(range.Range)) -> Int {
  ranges
  |> list.fold(0, fn(acc, range) {
    let range.Range(start, end) = range
    acc + { end - start + 1 }
  })
}
