import gleam/int
import gleam/list

pub type Operation {
  Addition
  Multiplication
}

pub type Problem =
  #(Operation, List(Int))

pub type Homework =
  List(Problem)

pub fn solve_homework(problems: List(Problem)) -> Int {
  problems |> list.map(solve_problem) |> int.sum
}

pub fn solve_problem(problem: Problem) -> Int {
  case problem {
    #(Addition, numbers) -> list.fold(numbers, 0, int.add)
    #(Multiplication, numbers) -> list.fold(numbers, 1, int.multiply)
  }
}
