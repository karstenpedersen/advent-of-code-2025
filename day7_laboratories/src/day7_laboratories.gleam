import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/set
import parser

pub fn main() -> Nil {
  case argv.load().arguments {
    [filepath] ->
      case parser.parse_input(filepath) {
        Ok(#(start, levels)) -> {
          let n_splits = solve_part1(start, levels) |> int.to_string
          io.println("Number of splits: " <> n_splits)
        }
        Error(error) -> io.println(parser.error_message(error))
      }
    _ -> io.println("Usage: command <filepath>")
  }
}

pub fn solve_part1(start: Int, levels: List(List(Int))) -> Int {
  echo start
  echo levels
  solve_part1_aux([start], levels)
}

pub fn solve_part1_aux(beams: List(Int), levels: List(List(Int))) -> Int {
  case levels {
    [] -> 0
    [level, ..rest] -> {
      let #(n_splits, next_beams) = shoot_beams(beams, level)
      // echo "START----------------"
      // echo beams as "BEAMS"
      // echo level as "LEVEL"
      echo n_splits as "N SPLITS"
      // echo next_beams as "NEXT_BEAMS"
      // echo "END----------------"
      n_splits + solve_part1_aux(next_beams, rest)
    }
  }
}

pub fn shoot_beams(beams: List(Int), splits: List(Int)) -> #(Int, List(Int)) {
  case splits {
    [] -> #(0, beams)
    splits -> {
      let #(used_beams, unused_beams) =
        beams |> list.partition(list.contains(splits, _))
      let new_beams =
        used_beams |> list.flat_map(fn(beam) { [beam - 1, beam + 1] })

      let next_beams =
        list.append(new_beams, unused_beams)
        |> list.unique
        |> list.sort(int.compare)

      // let old_beams = set.from_list(beams)
      // let new_beams = set.from_list(next_beams)
      // let diff = set.difference(new_beams, old_beams) |> set.size

      let diff =
        next_beams
        |> list.filter(fn(beam) { !list.contains(beams, beam) })
        |> list.length

      #(diff, next_beams)
    }
  }
}
