import argv
import error
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import parser

pub fn main() -> Nil {
  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(battery_lines) -> {
          case solve(battery_lines) {
            Ok(max_joltage) ->
              io.println("Max joltage: " <> int.to_string(max_joltage))
            Error(err) ->
              io.println(
                "Failed to find maximum joltage: " <> error.to_string(err),
              )
          }
        }
        Error(err) ->
          io.println("Failed to parse input file: " <> error.to_string(err))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

pub fn solve(battery_banks: List(List(Int))) -> Result(Int, error.CustomError) {
  battery_banks
  |> list.map(calculate_max_joltage)
  |> result.all
  |> result.map(int.sum)
}

fn calculate_max_joltage(
  battery_bank: List(Int),
) -> Result(Int, error.CustomError) {
  case battery_bank {
    [] ->
      Error(error.IncorrectNumberOfBatteriesError(
        "No batteries in battery bank",
      ))
    [_] ->
      Error(error.IncorrectNumberOfBatteriesError(
        "Only one battery available in bank",
      ))
    [x, y, ..rest] -> Ok(solve_aux(rest, x, y))
  }
}

fn solve_aux(battery_bank: List(Int), one: Int, two: Int) -> Int {
  let joltage = one * 10 + two

  case battery_bank {
    [] -> joltage
    [x, ..rest] if one * 10 + x > joltage && one * 10 + x >= two * 10 + x ->
      solve_aux(rest, one, x)
    [x, ..rest] if two * 10 + x > joltage && two * 10 + x > one * 10 + x ->
      solve_aux(rest, two, x)
    [_, ..rest] -> solve_aux(rest, one, two)
  }
}
