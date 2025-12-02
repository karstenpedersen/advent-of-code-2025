import error
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import range
import simplifile

/// Parse input file
pub fn parse_input(
  filepath: String,
) -> Result(List(range.Range), error.CustomError) {
  filepath
  |> simplifile.read
  |> result.map_error(fn(_) {
    error.ParseError("Failed to read file: " <> filepath)
  })
  |> result.try(fn(content) {
    content
    |> string.split(",")
    |> list.map(string.split(_, "-"))
    |> list.map(parse_range)
    |> result.all
    |> result.map(range.merge)
  })
}

/// Parse range from list of two strings
pub fn parse_range(
  range: List(String),
) -> Result(range.Range, error.CustomError) {
  case range {
    [start_string, end_string] -> {
      let start_result = parse_number(start_string)
      let end_result = parse_number(end_string)
      case start_result, end_result {
        Ok(start), Ok(end) -> Ok(range.Range(start, end))
        Error(e), _ -> Error(e)
        _, Error(e) -> Error(e)
      }
    }
    _ -> Error(error.ParseError("Invalid range format, expected 'start-end'"))
  }
}

/// Parse number from string
pub fn parse_number(s: String) -> Result(Int, error.CustomError) {
  int.parse(s)
  |> result.map_error(fn(_) { error.ParseError("Failed to parse number") })
}
