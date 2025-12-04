import gleam/float
import gleam/int
import gleam/list
import gleam/order
import gleam/result

pub type Battery {
  BatteryBank(batteries: List(Int), joltage: Int, length: Int)
}

pub fn new(batteries: List(Int)) -> Battery {
  let length = list.length(batteries)
  let joltage = calculate_joltage(batteries)

  BatteryBank(batteries:, joltage:, length:)
}

pub fn update(battery: Battery, new_value: Int, remove_index: Int) -> Battery {
  let before = battery.batteries |> list.take(battery.length - remove_index - 1)
  let after = battery.batteries |> list.drop(battery.length - remove_index)
  let batteries = before |> list.append(after) |> list.append([new_value])

  let joltage = calculate_joltage(batteries)

  BatteryBank(batteries:, joltage:, length: battery.length)
}

pub fn calculate_joltage(batteries: List(Int)) -> Int {
  let n = list.length(batteries)
  batteries
  |> list.index_fold(0, fn(acc, battery, index) {
    let assert Ok(p) =
      int.power(10, int.to_float(n - index - 1)) |> result.map(float.truncate)
    acc + battery * p
  })
}

pub fn compare(a: Battery, b: Battery) -> order.Order {
  case a.joltage, b.joltage {
    a, b if a < b -> order.Lt
    a, b if a > b -> order.Gt
    _, _ -> order.Eq
  }
}

pub fn max(a: Battery, b: Battery) -> Battery {
  case compare(a, b) {
    order.Lt -> b
    _ -> a
  }
}

pub fn optimize_battery(battery: Battery, new: Int) -> Battery {
  optimize_battery_aux(battery, new, battery.length - 1)
}

fn optimize_battery_aux(battery: Battery, new: Int, index: Int) -> Battery {
  case index {
    -1 -> battery
    index ->
      update(battery, new, index)
      |> max(battery)
      |> max(optimize_battery_aux(battery, new, index - 1))
  }
}
