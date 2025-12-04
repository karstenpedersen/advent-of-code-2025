import argv
import battery
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
          [2, 12]
          |> list.each(fn(n_needed_batteries) {
            case solve(battery_lines, n_needed_batteries) {
              Ok(max_joltage) ->
                io.println(
                  "Max joltage for "
                  <> int.to_string(n_needed_batteries)
                  <> " batteries: "
                  <> int.to_string(max_joltage),
                )
              Error(err) ->
                io.println(
                  "Failed to find maximum joltage for "
                  <> int.to_string(n_needed_batteries)
                  <> "batteries: "
                  <> error.to_string(err),
                )
            }
          })
        }
        Error(err) ->
          io.println("Failed to parse input file: " <> error.to_string(err))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

pub fn solve(
  battery_banks: List(List(Int)),
  n_needed_batteries: Int,
) -> Result(Int, error.CustomError) {
  battery_banks
  |> list.map(calculate_max_joltage(_, n_needed_batteries))
  |> result.all
  |> result.map(int.sum)
}

fn calculate_max_joltage(
  battery_bank: List(Int),
  n_needed_batteries: Int,
) -> Result(Int, error.CustomError) {
  let n_batteries = list.length(battery_bank)
  case n_batteries >= n_needed_batteries {
    True -> {
      let initial_batteries = list.take(battery_bank, n_needed_batteries)
      let rest_of_batteries = list.drop(battery_bank, n_needed_batteries)
      let battery_bank = battery.new(initial_batteries)
      let result = calculate_max_joltage_aux(rest_of_batteries, battery_bank)
      Ok(result.joltage)
    }
    False ->
      Error(error.InsufficientNumberOfBatteriesError(
        expected: n_needed_batteries,
        actual: n_batteries,
      ))
  }
}

fn calculate_max_joltage_aux(
  batteries: List(Int),
  battery: battery.Battery,
) -> battery.Battery {
  case batteries {
    [] -> battery
    [x, ..rest] -> {
      let new_battery =
        battery
        |> battery.optimize_battery(x)
        |> battery.max(battery)
      battery.max(new_battery, calculate_max_joltage_aux(rest, new_battery))
    }
  }
}
