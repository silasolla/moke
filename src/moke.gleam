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

pub const moke_caption_sleep = ":hamster:"

pub const moke_caption_awake = ":hamster: !!"

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
  html.main(
    [
      attribute.class(
        "max-w-xl mx-auto py-8 px-4 font-sans text-center text-gray-800",
      ),
    ],
    [header_view(), moke_view(model)],
  )
}

fn header_view() -> Element(Msg) {
  html.header([], [
    html.h1([attribute.class("text-4xl mb-1 tracking-wider")], [
      html.text(page_title),
    ]),
    html.p([attribute.class("mb-6 text-sm text-gray-400 tracking-wide")], [
      html.text(page_subtitle),
    ]),
  ])
}

fn moke_view(model: Model) -> Element(Msg) {
  let base_img_class =
    " col-start-1 row-start-1 max-w-full select-none cursor-pointer transition-opacity duration-500 drop-shadow-lg "
  let #(sleep_class, awake_class, figure_class, caption) = case model {
    Asleep -> #(
      base_img_class <> "opacity-100 animate-breathe",
      base_img_class <> "opacity-0",
      "m-0 hover:scale-105 transition-transform duration-200",
      moke_caption_sleep,
    )
    Awake -> #(
      base_img_class <> "opacity-0",
      base_img_class <> "opacity-100 animate-shake",
      "m-0",
      moke_caption_awake,
    )
  }
  html.figure([attribute.class(figure_class)], [
    html.div([attribute.class("grid place-items-center")], [
      html.img([
        attribute.src(moke_src_sleep),
        attribute.alt(moke_alt),
        attribute.attribute("draggable", "false"),
        event.on_click(ImageClicked),
        attribute.class(sleep_class),
      ]),
      html.img([
        attribute.src(moke_src_awake),
        attribute.alt(moke_alt),
        attribute.attribute("draggable", "false"),
        event.on_click(ImageClicked),
        attribute.class(awake_class),
      ]),
    ]),
    html.figcaption([attribute.class("mt-3 text-sm text-gray-500")], [
      html.text(caption),
    ]),
  ])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
