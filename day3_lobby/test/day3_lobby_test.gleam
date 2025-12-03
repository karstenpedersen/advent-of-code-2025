import day3_lobby
import error
import gleeunit
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_test() {
  part1_helper("./inputs/example_puzzle_input", 357)
}

pub fn puzzle_input_test() {
  part1_helper("./inputs/puzzle_input", 17_107)
}

pub fn one_battery_in_bank_test() {
  let assert Ok(battery_banks) =
    parser.parse_input("./inputs/one_battery_in_bank")
  let assert Error(error.IncorrectNumberOfBatteriesError(_)) =
    day3_lobby.solve(battery_banks)
}

fn part1_helper(filepath: String, expected_joltage: Int) {
  let assert Ok(battery_banks) = parser.parse_input(filepath)
  let assert Ok(max_joltage) = day3_lobby.solve(battery_banks)
  assert max_joltage == expected_joltage
}
