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
      attribute.style("max-width", "560px"),
      attribute.style("margin", "0 auto"),
      attribute.style("padding", "2rem 1rem"),
      attribute.style("font-family", "'Helvetica Neue', Arial, sans-serif"),
      attribute.style("text-align", "center"),
      attribute.style("color", "#333"),
    ],
    [header_view(), moke_view(model)],
  )
}

fn header_view() -> Element(Msg) {
  html.div([], [
    html.h1(
      [
        attribute.style("font-size", "2rem"),
        attribute.style("margin-bottom", "0.25rem"),
        attribute.style("letter-spacing", "0.05em"),
      ],
      [html.text(page_title)],
    ),
    html.p(
      [
        attribute.style("margin", "0 0 1.5rem"),
        attribute.style("font-size", "0.95rem"),
        attribute.style("color", "#888"),
        attribute.style("letter-spacing", "0.03em"),
      ],
      [html.text(page_subtitle)],
    ),
  ])
}

fn moke_view(model: Model) -> Element(Msg) {
  let src = case model {
    Asleep -> moke_src_sleep
    Awake -> moke_src_awake
  }
  html.figure([attribute.style("margin", "0")], [
    html.img([
      attribute.src(src),
      attribute.alt(moke_alt),
      event.on_click(ImageClicked),
      attribute.style("max-width", "100%"),
      attribute.style("border-radius", "12px"),
      attribute.style("box-shadow", "0 4px 16px rgba(0,0,0,0.15)"),
      attribute.style("cursor", "pointer"),
    ]),
    html.figcaption(
      [
        attribute.style("margin-top", "0.75rem"),
        attribute.style("font-size", "0.9rem"),
        attribute.style("color", "#666"),
      ],
      [html.text(moke_caption)],
    ),
  ])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
