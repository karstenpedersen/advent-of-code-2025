import day9_movie_theater
import gleeunit
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_for_part1_test() {
  part1_helper("./inputs/example_puzzle_input", 50)
}

// pub fn puzzle_input_for_part1_test() {
//   part1_helper("./inputs/puzzle_input", 1)
// }

// pub fn example_puzzle_input_for_part2_test() {
//   part2_helper("./inputs/example_puzzle_input", 50)
// }

// pub fn puzzle_input_for_part2_test() {
//   part2_helper("./inputs/puzzle_input", 2)
// }

fn part1_helper(filepath: String, expected_solution: Int) {
  let assert Ok(positions) = parser.parse_input(filepath)
  let assert Ok(solution) = day9_movie_theater.solve_part1(positions)
  assert solution == expected_solution
}
// fn part2_helper(filepath: String, expected_solution: Int) {
//   let assert Ok(positions) = parser.parse_input(filepath)
//   let assert Ok(solution) = day9_movie_theater.solve_part2(positions)
//   assert solution == expected_solution
// }
