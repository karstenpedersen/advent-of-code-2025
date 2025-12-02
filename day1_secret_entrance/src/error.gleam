pub type CustomError {
  ParseError(String)
}

pub fn to_string(error: CustomError) -> String {
  case error {
    ParseError(message) -> message
  }
}
