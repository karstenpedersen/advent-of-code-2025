import gleam/int

pub type CustomError {
  ParseError(String)
  InsufficientNumberOfBatteriesError(expected: Int, actual: Int)
}

pub fn to_string(error: CustomError) -> String {
  case error {
    ParseError(message) -> message
    InsufficientNumberOfBatteriesError(expected:, actual:) ->
      "Insufficient number of batteries. Expected "
      <> int.to_string(expected)
      <> " but found "
      <> int.to_string(actual)
  }
}
