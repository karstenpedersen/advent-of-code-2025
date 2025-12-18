import day7_laboratories
import gleeunit
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_for_part1_test() {
  part1_helper("./inputs/example_puzzle_input", 21)
}

pub fn puzzle_input_for_part1_test() {
  part1_helper("./inputs/puzzle_input", 5_667_835_681_547)
}

fn part1_helper(filepath: String, expected_solution: Int) {
  let assert Ok(#(start, levels)) = parser.parse_input(filepath)
  let solution = day7_laboratories.solve_part1(start, levels)
  assert solution == expected_solution
}
