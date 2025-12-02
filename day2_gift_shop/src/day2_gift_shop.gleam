import argv
import error
import gleam/io
import parser

pub fn main() -> Nil {
  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(ranges) -> {
          ranges
          |> echo as "Ranges"

          Nil
        }
        Error(error) -> io.println(error.to_string(error))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}
