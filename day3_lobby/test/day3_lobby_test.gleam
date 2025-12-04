import battery
import day3_lobby
import error
import gleeunit
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_for_two_battery_cells_test() {
  part1_helper("./inputs/example_puzzle_input", 357)
}

pub fn puzzle_input_for_two_battery_cells_test() {
  part1_helper("./inputs/puzzle_input", 17_107)
}

pub fn example_puzzle_input_for_twelve_battery_cells_test() {
  part2_helper("./inputs/example_puzzle_input", 3_121_910_778_619)
}

pub fn puzzle_input_for_twelve_battery_cells_test() {
  part2_helper("./inputs/puzzle_input", 169_349_762_274_117)
}

pub fn one_battery_in_bank_test() {
  let expected_number_of_batteries = 2
  let actual_number_of_batteries = 1

  let assert Ok(battery_banks) =
    parser.parse_input("./inputs/one_battery_in_bank")
  let assert Error(error.InsufficientNumberOfBatteriesError(expected:, actual:)) =
    day3_lobby.solve(battery_banks, expected_number_of_batteries)

  assert expected_number_of_batteries == expected
  assert actual_number_of_batteries == actual
}

pub fn initial_joltage_test() {
  let joltage = battery.calculate_joltage([8, 1, 9])
  assert joltage == 819
}

pub fn update_battery_of_length_three_test() {
  let expected_joltage = 134
  let battery = battery.new([1, 2, 3])
  let updated_battery = battery |> battery.update(4, 1)
  assert updated_battery.joltage == expected_joltage
}

pub fn update_battery_of_length_five_test() {
  let expected_joltage = 12_456
  let battery = battery.new([1, 2, 3, 4, 5])
  let updated_battery = battery |> battery.update(6, 2)
  assert updated_battery.joltage == expected_joltage
}

fn part1_helper(filepath: String, expected_joltage: Int) {
  let assert Ok(battery_banks) = parser.parse_input(filepath)
  let assert Ok(max_joltage) = day3_lobby.solve(battery_banks, 2)
  assert max_joltage == expected_joltage
}

fn part2_helper(filepath: String, expected_joltage: Int) {
  let assert Ok(battery_banks) = parser.parse_input(filepath)
  let assert Ok(max_joltage) = day3_lobby.solve(battery_banks, 12)
  assert max_joltage == expected_joltage
}
