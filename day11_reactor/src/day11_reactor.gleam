import argv
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import parser

pub fn main() -> Nil {
  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(graph) -> {
          echo graph
          let start = "you"
          let end = "out"
          let assert Ok(n_paths) =
            solve_part1(graph, start, end) |> result.map(int.to_string)
          io.println("#paths: " <> n_paths)
          Nil
        }
        Error(error) -> io.println(parser.error_message(error))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

pub fn solve_part1(
  graph: parser.Graph,
  start: parser.Device,
  end: parser.Device,
) -> Result(Int, parser.InputError) {
  todo
}

pub fn solve_part2(
  graph: parser.Graph,
  start: parser.Device,
  target: parser.Device,
) -> Result(Int, parser.InputError) {
  case dict.get(graph, start) {
    Ok(start_node) -> {
      let #(g, n_paths) = count_paths(graph, target, start_node)
      Ok(n_paths)
    }
    Error(_) -> Error(parser.InvalidCharacterInSplitLevelError)
  }
}

pub fn count_paths(
  graph: parser.Graph,
  target: parser.Device,
  node: parser.Node,
) -> #(parser.Graph, Int) {
  case node {
    #(neighbours, option.None) -> {
      neighbours
      |> list.fold(#(graph, 0), fn(acc, node_name) {
        let #(g, n_paths) = acc
        case dict.get(g, node_name) {
          Ok(node) if node_name == target -> {
            dict.insert(node_name, #(pair.first(node), option.Some(1)))
          }
          Ok(node) -> count_paths(g, target, node)
          Error(_) -> #(g, n_paths)
        }
      })
    }
    #(_, option.Some(n_paths)) -> #(graph, n_paths)
  }
}
