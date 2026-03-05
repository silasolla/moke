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

pub fn hamster_caption_test() {
  moke.moke_caption
  |> should.equal(":hamster:")
}

pub fn hamster_src_is_url_test() {
  moke.moke_src
  |> string.starts_with("https://")
  |> should.be_true
}

pub fn hamster_src_references_hamster_test() {
  moke.moke_src
  |> string.lowercase
  |> string.contains("hamster")
  |> should.be_true
}
