import argv
import gleam/int
import gleam/io
import math_homework
import parser

pub fn main() -> Nil {
  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(homework) -> {
          let solution =
            math_homework.solve_homework(homework) |> int.to_string()
          io.println("Solution: " <> solution)
        }
        Error(error) -> io.println(parser.error_message(error))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}
