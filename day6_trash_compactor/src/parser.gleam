import gleam/int
import gleam/list
import gleam/result
import gleam/string
import math_homework
import simplifile

pub type InputError {
  InputReadError(filepath: String)
  InvalidValueError(value: String)
  EmptyInputError
  InvalidOperationError
  InvalidColumnError
}

pub fn parse_input(
  filepath: String,
) -> Result(math_homework.Homework, InputError) {
  filepath
  |> simplifile.read
  |> result.map_error(fn(_) { InputReadError(filepath) })
  |> result.try(parse_content)
}

fn parse_content(content: String) -> Result(math_homework.Homework, InputError) {
  content
  |> string.split("\n")
  |> list.reverse
  |> list.map(fn(value) {
    value
    |> string.split(" ")
    |> list.map(string.trim)
    |> list.filter(fn(value) { !string.is_empty(value) })
  })
  |> list.transpose
  |> list.try_map(parse_problem_column)
}

fn parse_operation(
  operation: String,
) -> Result(math_homework.Operation, InputError) {
  case operation {
    "+" -> Ok(math_homework.Addition)
    "*" -> Ok(math_homework.Multiplication)
    _ -> Error(InvalidOperationError)
  }
}

fn parse_problem_column(
  column: List(String),
) -> Result(math_homework.Problem, InputError) {
  case column {
    [operation, ..rest] -> {
      let operation = parse_operation(operation)
      let numbers = rest |> list.reverse |> list.try_map(parse_number)

      case operation, numbers {
        Ok(operation), Ok(numbers) -> Ok(#(operation, numbers))
        Error(error), _ -> Error(error)
        _, Error(error) -> Error(error)
      }
    }
    _ -> Error(InvalidColumnError)
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
    InvalidOperationError -> "Invalid operation found"
    InvalidColumnError -> "Invalid column error"
  }
}
