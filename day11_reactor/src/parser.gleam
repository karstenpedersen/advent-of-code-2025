import gleam/dict
import gleam/list
import gleam/option
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

pub type Device =
  String

pub type Node =
  #(List(Device), option.Option(Int))

pub type Graph =
  dict.Dict(Device, Node)

pub fn parse_input(filepath: String) -> Result(Graph, InputError) {
  filepath
  |> simplifile.read
  |> result.map_error(fn(_) { InputReadError(filepath) })
  |> result.map(string.split(_, "\n"))
  |> result.try(parse_lines)
}

pub fn parse_lines(lines: List(String)) -> Result(Graph, InputError) {
  lines
  |> list.fold(Ok(dict.new()), fn(acc, line) {
    case acc, parse_line(line) {
      Ok(acc), Ok(#(key, value)) ->
        Ok(dict.insert(acc, key, #(value, option.None)))
      _, Error(error) -> Error(error)
      Error(error), _ -> Error(error)
    }
  })
}

pub fn parse_line(line: String) -> Result(#(Device, List(Device)), InputError) {
  let result = line |> string.replace(":", "") |> string.split(" ")
  case result {
    [node, ..rest] -> Ok(#(node, rest))
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
    InvalidPositionFormat -> "Invalid number format"
  }
}
