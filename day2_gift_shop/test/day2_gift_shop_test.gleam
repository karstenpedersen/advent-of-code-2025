import gleeunit
import parser
import range

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn range_overlap_test() {
  let filepath = "./inputs/overlapping_ranges"
  let correct_ranges = [range.Range(299, 600), range.Range(1, 201)]

  let assert Ok(ranges) = parser.parse_input(filepath)

  assert correct_ranges == ranges
}
