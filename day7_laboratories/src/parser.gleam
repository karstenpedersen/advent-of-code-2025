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
}

pub type Position {
  Position(x: Int, y: Int)
}

pub type ParsedInput =
  #(Int, List(List(Int)))

pub fn parse_input(filepath: String) -> Result(ParsedInput, InputError) {
  filepath
  |> simplifile.read
  |> result.map_error(fn(_) { InputReadError(filepath) })
  |> result.try(parse_content)
}

fn parse_content(content: String) -> Result(ParsedInput, InputError) {
  let levels =
    content
    |> string.split("\n")
    |> list.map(string.split(_, ""))

  case levels {
    [start_level, ..rest] -> {
      let start_result = parse_start(start_level)
      let levels_result =
        rest
        |> list.try_map(parse_splits)
        |> result.map(list.filter(_, fn(level) { !list.is_empty(level) }))
      case start_result, levels_result {
        Ok(start), Ok(levels) -> Ok(#(start, levels))
        Error(error), _ -> Error(error)
        _, Error(error) -> Error(error)
      }
    }
    [] -> Error(EmptyInputError)
  }
}

fn parse_start(level: List(String)) -> Result(Int, InputError) {
  parse_start_aux(level, 0)
}

fn parse_start_aux(level: List(String), index: Int) -> Result(Int, InputError) {
  case level {
    [] -> Error(NoStartError)
    ["S", ..] -> Ok(index)
    [".", ..rest] -> parse_start_aux(rest, index + 1)
    _ -> Error(InvalidCharacterInStartLevelError)
  }
}

fn parse_splits(level: List(String)) -> Result(List(Int), InputError) {
  parse_splits_aux(level, 0)
}

fn parse_splits_aux(
  level: List(String),
  index: Int,
) -> Result(List(Int), InputError) {
  case level {
    [] -> Ok([])
    ["^", ..rest] ->
      parse_splits_aux(rest, index + 1) |> result.map(list.prepend(_, index))
    [".", ..rest] -> parse_splits_aux(rest, index + 1)
    _ -> Error(InvalidCharacterInSplitLevelError)
  }
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
  }
}
