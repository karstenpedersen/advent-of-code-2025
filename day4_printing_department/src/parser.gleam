import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type PositionValue {
  PaperRoll
  Empty
}

pub type LookupMap =
  dict.Dict(#(Int, Int), Nil)

pub type InputError {
  InputReadError(filepath: String)
  InvalidValueError(value: String)
  InconsistentGridWidthError
  FilterError
}

/// Parse input file
pub fn parse_input(filepath: String) -> Result(LookupMap, InputError) {
  filepath
  |> simplifile.read
  |> result.map_error(fn(_) { InputReadError(filepath) })
  |> result.try(parse_content)
}

/// Parse grid content
fn parse_content(content: String) -> Result(LookupMap, InputError) {
  let grid_result =
    content
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.filter(fn(line) { string.length(line) > 0 })
    |> list.fold_until(Ok(#(0, [])), fn(acc, line) {
      let assert Ok(#(current_width, flat_items)) = acc
      let items_result =
        line
        |> string.split("")
        |> list.try_map(parse_char)

      case items_result {
        Ok(items) -> {
          let width = list.length(items)
          case current_width {
            _ if current_width == 0 || current_width == width ->
              list.Continue(Ok(#(width, list.append(flat_items, items))))
            _ -> list.Stop(Error(InconsistentGridWidthError))
          }
        }
        Error(err) -> list.Stop(Error(err))
      }
    })

  case grid_result {
    Ok(#(width, items)) -> {
      let map =
        items
        |> list.index_map(fn(item, index) {
          let assert Ok(x) = int.modulo(index, width)
          let assert Ok(y) = int.divide(index, width)
          #(#(x, y), item)
        })
        |> list.filter_map(fn(value) {
          case value {
            #(key, value) if value == PaperRoll -> Ok(#(key, Nil))
            _ -> Error(FilterError)
          }
        })
        |> dict.from_list

      Ok(map)
    }
    Error(error) -> Error(error)
  }
}

fn parse_char(char: String) -> Result(PositionValue, InputError) {
  case char {
    "@" -> Ok(PaperRoll)
    "." -> Ok(Empty)
    x -> Error(InvalidValueError(x))
  }
}

pub fn error_message(error: InputError) -> String {
  case error {
    InconsistentGridWidthError -> "Inconistent grid width"
    InputReadError(filepath:) -> "Failed to read inputfile: " <> filepath
    InvalidValueError(value:) -> "Invalid cell value found: " <> value
    FilterError -> "Just for typing"
  }
}
