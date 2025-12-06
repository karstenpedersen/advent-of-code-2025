import gleeunit
import math_homework
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_for_part1_test() {
  part1_helper("./inputs/example_puzzle_input", 4_277_556)
}

pub fn puzzle_input_for_part1_test() {
  part1_helper("./inputs/puzzle_input", 5_667_835_681_547)
}

fn part1_helper(filepath: String, expected_solution: Int) {
  let assert Ok(homework) = parser.parse_input(filepath)
  let solution = math_homework.solve_homework(homework)
  assert solution == expected_solution
}
