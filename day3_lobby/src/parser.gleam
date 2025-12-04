import error
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn parse_input(
  filepath: String,
) -> Result(List(List(Int)), error.CustomError) {
  case simplifile.read(from: filepath) {
    Ok(content) -> {
      content
      |> string.split("\n")
      |> list.filter(fn(line) { !string.is_empty(line) })
      |> list.map(fn(line) {
        line |> string.split("") |> list.map(parse_number) |> result.all
      })
      |> result.all
    }
    Error(_) -> Error(error.ParseError("Failed to read file " <> filepath))
  }
}

fn parse_number(s: String) -> Result(Int, error.CustomError) {
  int.parse(s)
  |> result.map_error(fn(_) { error.ParseError("Failed to parse number") })
}
