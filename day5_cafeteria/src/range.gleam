import gleam/int
import gleam/list

/// Range record
pub type Range {
  Range(Int, Int)
}

/// Gets start value of range
pub fn start(range: Range) -> Int {
  let Range(start, _end) = range
  start
}

/// Gets end value of range
pub fn end(range: Range) -> Int {
  let Range(_start, end) = range
  end
}

/// Converts range to string representation
pub fn to_string(range: Range) -> String {
  let Range(start, end) = range
  int.to_string(start) <> "-" <> int.to_string(end)
}

/// Merges list of ranges
pub fn merge(ranges: List(Range)) -> List(Range) {
  ranges
  |> list.sort(fn(a, b) { int.compare(start(a), start(b)) })
  |> list.fold([], fn(acc, range) {
    let Range(start, end) = range
    case acc {
      [Range(last_start, last_end), ..rest] if last_end + 1 >= start ->
        list.prepend(rest, Range(last_start, int.max(last_end, end)))
      acc -> list.prepend(acc, range)
    }
  })
}

/// Check if value is within range
pub fn is_inside(range: Range, value: Int) -> Bool {
  let Range(start, end) = range
  value >= start && value <= end
}
