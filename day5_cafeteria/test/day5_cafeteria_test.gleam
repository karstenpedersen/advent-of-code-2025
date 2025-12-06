import day5_cafeteria
import gleeunit
import parser

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_puzzle_input_for_part1_test() {
  part1_helper("./inputs/example_puzzle_input", 3)
}

pub fn puzzle_input_for_part1_test() {
  part1_helper("./inputs/puzzle_input", 517)
}

pub fn example_puzzle_input_for_part2_test() {
  part2_helper("./inputs/example_puzzle_input", 14)
}

pub fn puzzle_input_for_part2_test() {
  part2_helper("./inputs/puzzle_input", 336_173_027_056_994)
}

fn part1_helper(filepath: String, expected_fresh_ingredients: Int) {
  let assert Ok(#(ranges, ids)) = parser.parse_input(filepath)
  let n_fresh_ingredients = day5_cafeteria.solve_part1(ranges, ids)
  assert n_fresh_ingredients == expected_fresh_ingredients
}

fn part2_helper(filepath: String, expexpected_fresh_ingredients: Int) {
  let assert Ok(#(ranges, _ids)) = parser.parse_input(filepath)
  let total_fresh_ingredient_ids = day5_cafeteria.solve_part2(ranges)
  assert total_fresh_ingredient_ids == expexpected_fresh_ingredients
}
