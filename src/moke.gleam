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

pub const moke_src_tired = "https://image.silasol.la/moke/tired.webp"

pub const moke_alt_sleep = "もけすやすや"

pub const moke_alt_awake = "もけおはよう"

pub const moke_alt_tired = "もけつかれた"

pub const moke_caption_sleep = ":hamster:"

pub const moke_caption_awake = ":hamster: (｀･ω･´)"

pub const moke_caption_tired = ":hamster: ( ´△｀)"

pub const awake_duration_ms = 5000

pub const tired_duration_ms = 3000

pub const wake_threshold = 5

pub type Model {
  Asleep(wake_count: Int)
  Awake(wake_count: Int)
  Tired
}

pub type Msg {
  ImageClicked
  FellAsleep
  RecoveredFromTired
}

pub fn init(_flags: Nil) -> #(Model, effect.Effect(Msg)) {
  #(Asleep(0), effect.none())
}

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    ImageClicked ->
      case model {
        Asleep(n) -> #(Awake(n + 1), delay_msg(FellAsleep, awake_duration_ms))
        Awake(_) | Tired -> #(model, effect.none())
      }
    FellAsleep ->
      case model {
        Awake(n) ->
          case n >= wake_threshold {
            True -> #(Tired, delay_msg(RecoveredFromTired, tired_duration_ms))
            False -> #(Asleep(n), effect.none())
          }
        Asleep(_) | Tired -> #(model, effect.none())
      }
    RecoveredFromTired -> #(Asleep(0), effect.none())
  }
}

fn delay_msg(msg: Msg, ms: Int) -> effect.Effect(Msg) {
  effect.from(fn(dispatch) { set_timeout(fn() { dispatch(msg) }, ms) })
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

fn moke_image_layer(
  src: String,
  alt: String,
  is_active: Bool,
  active_animation: String,
) -> Element(Msg) {
  html.img([
    attribute.src(src),
    attribute.alt(alt),
    attribute.attribute("draggable", "false"),
    attribute.classes([
      #(
        "col-start-1 row-start-1 max-w-full select-none cursor-pointer transition-opacity duration-500 drop-shadow-lg",
        True,
      ),
      #("opacity-100 " <> active_animation, is_active),
      #("opacity-0", !is_active),
    ]),
  ])
}

fn moke_view(model: Model) -> Element(Msg) {
  let #(figure_class, caption) = case model {
    Asleep(_) -> #(
      "m-0 hover:scale-105 transition-transform duration-200",
      moke_caption_sleep,
    )
    Awake(_) -> #("m-0", moke_caption_awake)
    Tired -> #("m-0", moke_caption_tired)
  }
  html.figure([attribute.class(figure_class)], [
    // 3枚の画像を CSS grid で同セルに重ねて配置し opacity で切り替えるクロスフェード
    // opacity-0 の画像もポインタイベントを受け取るためにクリックは親 div でまとめて処理する
    html.div(
      [attribute.class("grid place-items-center"), event.on_click(ImageClicked)],
      [
        moke_image_layer(
          moke_src_sleep,
          moke_alt_sleep,
          case model {
            Asleep(_) -> True
            _ -> False
          },
          "animate-breathe",
        ),
        moke_image_layer(
          moke_src_awake,
          moke_alt_awake,
          case model {
            Awake(_) -> True
            _ -> False
          },
          "animate-shake",
        ),
        moke_image_layer(
          moke_src_tired,
          moke_alt_tired,
          case model {
            Tired -> True
            _ -> False
          },
          "animate-breathe",
        ),
      ],
    ),
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
