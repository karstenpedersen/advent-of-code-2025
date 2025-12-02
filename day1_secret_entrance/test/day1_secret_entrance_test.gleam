import day1_secret_entrance
import gleeunit
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_test() {
  part1_helper("./inputs/test_input", 3)
}

pub fn puzzle_input_test() {
  part1_helper("./inputs/input", 995)
}

fn part1_helper(filepath: String, correct_password: Int) {
  let initial_dial_position = 50
  let max_dial_position = 99

  let assert Ok(rotations) = parser.parse_input(filepath)
  let assert Ok(password) =
    day1_secret_entrance.crack_code_part1(
      rotations,
      initial_dial_position,
      max_dial_position,
    )
  assert password == correct_password
}
