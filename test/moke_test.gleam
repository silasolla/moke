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

pub fn moke_src_is_url_test() {
  moke.moke_src
  |> string.starts_with("https://")
  |> should.be_true
}
