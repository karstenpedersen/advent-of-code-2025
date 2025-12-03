pub type CustomError {
  ParseError(String)
  IncorrectNumberOfBatteriesError(String)
}

pub fn to_string(error: CustomError) -> String {
  case error {
    ParseError(message) -> message
    IncorrectNumberOfBatteriesError(message) -> message
  }
}
