import gleam/int
import gleam/list
import gleam/result
import gleam/string
import range
import simplifile

pub type InputError {
  InputReadError(filepath: String)
  InvalidValueError(value: String)
  InconsistentGridWidthError
  FilterError
  RangeFormatError
  InvalidInputFormat
}

/// Parse input file
pub fn parse_input(
  filepath: String,
) -> Result(#(List(range.Range), List(Int)), InputError) {
  filepath
  |> simplifile.read
  |> result.map_error(fn(_) { InputReadError(filepath) })
  |> result.try(parse_content)
}

/// Parse range and id block
fn parse_content(
  content: String,
) -> Result(#(List(range.Range), List(Int)), InputError) {
  let blocks =
    content
    |> string.split("\n\n")

  case blocks {
    [range_block, id_block] -> {
      let range_result = range_block |> string.split("\n") |> parse_ranges
      let id_result =
        id_block |> string.split("\n") |> list.map(parse_number) |> result.all
      case range_result, id_result {
        Ok(ranges), Ok(ids) -> Ok(#(ranges, ids))
        Error(error), _ -> Error(error)
        _, Error(error) -> Error(error)
      }
    }
    _ -> Error(InvalidInputFormat)
  }
}

pub fn parse_ranges(
  lines: List(String),
) -> Result(List(range.Range), InputError) {
  let ranges_result =
    lines
    |> list.fold_until(Ok([]), fn(acc, line) {
      let assert Ok(ranges) = acc

      let range_result =
        line
        |> string.split("-")
        |> parse_range

      case range_result {
        Ok(range) -> list.Continue(Ok(list.prepend(ranges, range)))
        Error(err) -> list.Stop(Error(err))
      }
    })

  case ranges_result {
    Ok(ranges) -> Ok(ranges |> range.merge)
    Error(error) -> Error(error)
  }
}

pub fn parse_range(range: List(String)) -> Result(range.Range, InputError) {
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
    _ -> Error(RangeFormatError)
  }
}

fn parse_number(s: String) -> Result(Int, InputError) {
  int.parse(s)
  |> result.map_error(fn(_) { InputReadError("Failed to parse number") })
}

pub fn error_message(error: InputError) -> String {
  case error {
    InconsistentGridWidthError -> "Inconistent grid width"
    InputReadError(filepath:) -> "Failed to read inputfile: " <> filepath
    InvalidValueError(value:) -> "Invalid cell value found: " <> value
    FilterError -> "Just for typing"
    InvalidInputFormat -> "Invalid input format"
    RangeFormatError -> "Invalid range format"
  }
}
