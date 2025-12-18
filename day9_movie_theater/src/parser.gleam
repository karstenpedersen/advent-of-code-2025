import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type InputError {
  InputReadError(filepath: String)
  InvalidValueError(value: String)
  EmptyInputError
  NoStartError
  InvalidCharacterInSplitLevelError
  InvalidCharacterInStartLevelError
  InvalidPositionFormat
}

pub type Position {
  Position(x: Int, y: Int)
}

pub type ParsedInput =
  #(Int, List(List(Int)))

pub fn parse_input(filepath: String) -> Result(List(Position), InputError) {
  filepath
  |> simplifile.read
  |> result.map_error(fn(_) { InputReadError(filepath) })
  |> result.map(string.split(_, "\n"))
  |> result.try(parse_positions)
}

pub fn parse_positions(
  lines: List(String),
) -> Result(List(Position), InputError) {
  lines
  |> list.fold_until(Ok([]), fn(acc, line) {
    let assert Ok(ranges) = acc

    let position_result =
      line
      |> string.split(",")
      |> parse_position

    case position_result {
      Ok(position) -> list.Continue(Ok(list.prepend(ranges, position)))
      Error(err) -> list.Stop(Error(err))
    }
  })
}

pub fn parse_position(position: List(String)) -> Result(Position, InputError) {
  case position {
    [x_string, y_string] -> {
      let x_result = parse_number(x_string)
      let y_result = parse_number(y_string)
      case x_result, y_result {
        Ok(x), Ok(y) -> Ok(Position(x, y))
        Error(e), _ -> Error(e)
        _, Error(e) -> Error(e)
      }
    }
    _ -> Error(InvalidPositionFormat)
  }
}

fn parse_number(s: String) -> Result(Int, InputError) {
  int.parse(s)
  |> result.map_error(fn(_) { InputReadError("Failed to parse number") })
}

pub fn error_message(error: InputError) -> String {
  case error {
    InputReadError(filepath:) -> "Failed to read inputfile: " <> filepath
    InvalidValueError(value:) -> "Invalid cell value found: " <> value
    EmptyInputError -> "Input is empty"
    NoStartError -> "Could not find a start in input"
    InvalidCharacterInSplitLevelError ->
      "Invalid character found in split level"
    InvalidCharacterInStartLevelError ->
      "Invalid character found in start level"
    InvalidPositionFormat -> "Invalid number format"
  }
}
