import gleeunit
import gleeunit/should
import moke

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn init_is_asleep_test() {
  let #(model, _) = moke.init(Nil)
  model |> should.equal(moke.Asleep(0))
}

pub fn click_wakes_up_test() {
  let #(model, _) = moke.update(moke.Asleep(0), moke.ImageClicked)
  model |> should.equal(moke.Awake(1))
}

pub fn click_while_awake_stays_awake_test() {
  let #(model, _) = moke.update(moke.Awake(2), moke.ImageClicked)
  model |> should.equal(moke.Awake(2))
}

pub fn click_while_tired_is_ignored_test() {
  let #(model, _) = moke.update(moke.Tired, moke.ImageClicked)
  model |> should.equal(moke.Tired)
}

pub fn fell_asleep_before_threshold_test() {
  let #(model, _) =
    moke.update(moke.Awake(moke.wake_threshold - 1), moke.FellAsleep)
  model |> should.equal(moke.Asleep(moke.wake_threshold - 1))
}

pub fn fell_asleep_at_threshold_becomes_tired_test() {
  let #(model, _) =
    moke.update(moke.Awake(moke.wake_threshold), moke.FellAsleep)
  model |> should.equal(moke.Tired)
}

pub fn fell_asleep_from_asleep_stays_asleep_test() {
  let #(model, _) = moke.update(moke.Asleep(0), moke.FellAsleep)
  model |> should.equal(moke.Asleep(0))
}

pub fn recovered_from_tired_becomes_asleep_test() {
  let #(model, _) = moke.update(moke.Tired, moke.RecoveredFromTired)
  model |> should.equal(moke.Asleep(0))
}
