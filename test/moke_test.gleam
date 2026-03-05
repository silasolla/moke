import gleam/string
import gleeunit
import gleeunit/should
import moke

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn page_title_test() {
  moke.page_title
  |> should.equal("もけ寄生")
}

pub fn page_subtitle_test() {
  moke.page_subtitle
  |> should.equal("my site's little resident")
}

pub fn moke_caption_test() {
  moke.moke_caption
  |> should.equal(":hamster:")
}

pub fn moke_src_sleep_is_url_test() {
  moke.moke_src_sleep
  |> string.starts_with("https://")
  |> should.be_true
}

pub fn moke_src_awake_is_url_test() {
  moke.moke_src_awake
  |> string.starts_with("https://")
  |> should.be_true
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

pub fn fell_asleep_reverts_test() {
  let #(model, _) = moke.update(moke.Awake, moke.FellAsleep)
  model |> should.equal(moke.Asleep)
}
