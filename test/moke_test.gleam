import gleeunit
import gleeunit/should
import moke

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn init_is_asleep_test() {
  let #(model, _) = moke.init(Nil)
  model |> should.equal(moke.Asleep)
}

pub fn click_wakes_up_test() {
  let #(model, _) = moke.update(moke.Asleep, moke.ImageClicked)
  model |> should.equal(moke.Awake)
}

pub fn click_while_awake_stays_awake_test() {
  let #(model, _) = moke.update(moke.Awake, moke.ImageClicked)
  model |> should.equal(moke.Awake)
}

pub fn fell_asleep_from_awake_test() {
  let #(model, _) = moke.update(moke.Awake, moke.FellAsleep)
  model |> should.equal(moke.Asleep)
}

pub fn fell_asleep_from_asleep_test() {
  let #(model, _) = moke.update(moke.Asleep, moke.FellAsleep)
  model |> should.equal(moke.Asleep)
}
