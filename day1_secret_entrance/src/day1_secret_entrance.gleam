import argv
import error
import gleam/int
import gleam/io
import gleam/list
import parser

pub fn main() -> Nil {
  let initial_dial_position = 50
  let max_dial_position = 99

  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(rotations) -> {
          let assert Ok(password1) =
            crack_code_part1(
              rotations,
              initial_dial_position,
              max_dial_position,
            )

          io.println("Password 1: " <> int.to_string(password1))
        }
        Error(err) ->
          io.println("Failed to parse input file: " <> error.to_string(err))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

pub fn crack_code_part1(
  rotations: List(Int),
  initial_dial_position: Int,
  max_dial_position: Int,
) -> Result(Int, error.CustomError) {
  let #(_, password) =
    rotations
    |> list.fold(#(initial_dial_position, 0), fn(acc, rotation) {
      let #(dial_position, number_of_zeros) = acc
      let assert Ok(dial_position) =
        int.modulo(dial_position + rotation, max_dial_position + 1)

      #(
        dial_position,
        number_of_zeros
          + case dial_position {
          0 -> 1
          _ -> 0
        },
      )
    })
  Ok(password)
}
