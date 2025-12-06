import argv
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import parser

type SolverError {
  SolverError(String)
}

pub fn main() -> Nil {
  let max_neighbours = 4
  case argv.load().arguments {
    ["part1", filepath] ->
      case parser.parse_input(filepath) {
        Ok(lookup_map) -> {
          let available_rolls_of_paper =
            lookup_map
            |> echo
            |> solve_part1(max_neighbours)
            |> int.to_string

          io.println("Available rolls of paper: " <> available_rolls_of_paper)
        }
        Error(err) -> io.println(parser.error_message(err))
      }
    ["part2", filepath] ->
      case parser.parse_input(filepath) {
        Ok(grid) -> {
          let available_rolls_of_paper =
            grid
            |> solve_part2(max_neighbours)
            |> int.to_string

          io.println("Available rolls of paper: " <> available_rolls_of_paper)
        }
        Error(err) -> io.println(parser.error_message(err))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

/// Counts number of available rolls of paper
pub fn solve_part1(
  neighbour_map: parser.LookupMap,
  max_surrounding_rolls_of_paper: Int,
) -> Int {
  dict.fold(neighbour_map, 0, fn(acc, key, _) {
    let n_neighbours =
      key
      |> neigbour_positions
      |> list.filter_map(fn(neighbour) {
        case dict.has_key(neighbour_map, neighbour) {
          True -> Ok(neighbour)
          False -> Error(SolverError)
        }
      })
      |> list.length

    case n_neighbours < max_surrounding_rolls_of_paper {
      True -> acc + 1
      False -> acc
    }
  })
}

/// Counts total number of available rolls of paper
pub fn solve_part2(
  neighbour_map: parser.LookupMap,
  max_surrounding_rolls_of_paper: Int,
) -> Int {
  let #(new_neighbour_map, count) =
    dict.fold(neighbour_map, #(neighbour_map, 0), fn(acc, key, _) {
      let #(acc_map, acc_count) = acc
      let n_neighbours =
        key
        |> neigbour_positions
        |> list.filter_map(fn(neighbour) {
          case dict.has_key(neighbour_map, neighbour) {
            True -> Ok(neighbour)
            False -> Error(SolverError)
          }
        })
        |> list.length

      case n_neighbours < max_surrounding_rolls_of_paper {
        True -> #(acc_map |> dict.delete(key), acc_count + 1)
        False -> #(acc_map, acc_count)
      }
    })

  case new_neighbour_map == neighbour_map {
    True -> count
    False ->
      count + solve_part2(new_neighbour_map, max_surrounding_rolls_of_paper)
  }
}

pub fn neigbour_positions(position: #(Int, Int)) -> List(#(Int, Int)) {
  let #(x, y) = position
  [
    #(x - 1, y + 1),
    #(x, y + 1),
    #(x + 1, y + 1),
    #(x + 1, y),
    #(x + 1, y - 1),
    #(x, y - 1),
    #(x - 1, y - 1),
    #(x - 1, y),
  ]
}
