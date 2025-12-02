import error
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn parse_input(filepath: String) -> Result(List(Int), error.CustomError) {
  case simplifile.read(from: filepath) {
    Ok(content) ->
      string.split(content, "\n")
      |> list.map(string.trim)
      |> list.filter(fn(line) { !string.is_empty(line) })
      |> list.try_map(parse_line)
    Error(_) -> Error(error.ParseError("Failed to read file: " <> filepath))
  }
}

fn parse_line(line: String) -> Result(Int, error.CustomError) {
  case string.pop_grapheme(line) {
    Ok(#("L", rest)) -> parse_number(rest) |> result.map(int.negate)
    Ok(#("R", rest)) -> parse_number(rest)
    Ok(#(prefix, _rest)) ->
      Error(error.ParseError("Invalid rotation prefix: " <> prefix))
    Error(_) -> Error(error.ParseError("Error getting line prefix"))
  }
}

fn parse_number(s: String) -> Result(Int, error.CustomError) {
  int.parse(s)
  |> result.map_error(fn(_) { error.ParseError("Failed to parse number") })
}
