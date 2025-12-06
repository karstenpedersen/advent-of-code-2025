import day4_printing_department
import gleeunit
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_for_part1_test() {
  part1_helper("./inputs/example_puzzle_input", 13)
}

pub fn puzzle_input_for_part1_test() {
  part1_helper("./inputs/puzzle_input", 1467)
}

pub fn example_puzzle_input_for_part2_test() {
  part2_helper("./inputs/example_puzzle_input", 43)
}

pub fn puzzle_input_for_part2_test() {
  part2_helper("./inputs/puzzle_input", 8484)
}

pub fn n_neighbours_test() {
  let filepath = "inputs/test"
  let assert Ok(grid) = parser.parse_input(filepath)
  let number_of_paper_rolls = day4_printing_department.solve_part1(grid, 4)
  assert number_of_paper_rolls == 4
}

fn part1_helper(filepath: String, expected_available_rolls_of_paper: Int) {
  let assert Ok(grid) = parser.parse_input(filepath)
  let available_rolls_of_paper = day4_printing_department.solve_part1(grid, 4)
  assert available_rolls_of_paper == expected_available_rolls_of_paper
}

fn part2_helper(filepath: String, expected_available_rolls_of_paper: Int) {
  let assert Ok(grid) = parser.parse_input(filepath)
  let total_available_rolls_of_paper =
    day4_printing_department.solve_part2(grid, 4)
  assert total_available_rolls_of_paper == expected_available_rolls_of_paper
}
