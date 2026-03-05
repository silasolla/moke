import lustre
import lustre/attribute
import lustre/effect
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub const page_title = "もけ寄生"

pub const page_subtitle = "my site's little resident"

pub const moke_src_sleep = "https://image.silasol.la/moke/sleep.webp"

pub const moke_src_awake = "https://image.silasol.la/moke/awake.webp"

pub const moke_alt = "もけだよ"

pub const moke_caption = ":hamster:"

pub const awake_duration_ms = 5000

pub type Model {
  Asleep
  Awake
}

pub type Msg {
  ImageClicked
  FellAsleep
}

pub fn init(_flags: Nil) -> #(Model, effect.Effect(Msg)) {
  #(Asleep, effect.none())
}

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    ImageClicked ->
      case model {
        Asleep -> #(Awake, revert_after(awake_duration_ms))
        Awake -> #(Awake, effect.none())
      }
    FellAsleep -> #(Asleep, effect.none())
  }
}

fn revert_after(ms: Int) -> effect.Effect(Msg) {
  effect.from(fn(dispatch) { set_timeout(fn() { dispatch(FellAsleep) }, ms) })
}

@external(javascript, "./moke_ffi.mjs", "setTimeoutFn")
fn set_timeout(callback: fn() -> Nil, ms: Int) -> Nil

pub fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "max-w-[560px] mx-auto py-8 px-4 font-sans text-center text-[#333]",
      ),
    ],
    [header_view(), moke_view(model)],
  )
}

fn header_view() -> Element(Msg) {
  html.div([], [
    html.h1([attribute.class("text-[2rem] mb-1 tracking-[0.05em]")], [
      html.text(page_title),
    ]),
    html.p(
      [attribute.class("mb-6 text-[0.95rem] text-[#888] tracking-[0.03em]")],
      [html.text(page_subtitle)],
    ),
  ])
}

fn moke_view(model: Model) -> Element(Msg) {
  let src = case model {
    Asleep -> moke_src_sleep
    Awake -> moke_src_awake
  }
  html.figure([attribute.class("m-0")], [
    html.img([
      attribute.src(src),
      attribute.alt(moke_alt),
      event.on_click(ImageClicked),
      attribute.class("max-w-full rounded-xl shadow-lg cursor-pointer"),
    ]),
    html.figcaption([attribute.class("mt-3 text-[0.9rem] text-[#666]")], [
      html.text(moke_caption),
    ]),
  ])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
