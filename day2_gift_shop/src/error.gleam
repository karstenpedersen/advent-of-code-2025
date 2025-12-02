pub type CustomError {
  ParseError(String)
}

/// Gets string representation of error
pub fn to_string(error: CustomError) -> String {
  case error {
    ParseError(message) -> "Failed to parse input file: " <> message
  }
}
