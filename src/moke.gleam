import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub const page_title = "もけ寄生"

pub const moke_src = "https://image.silasol.la/moke/sleep.webp"

pub const moke_caption = ":hamster:"

pub fn view() -> Element(Nil) {
  html.div(
    [
      attribute.style("max-width", "560px"),
      attribute.style("margin", "0 auto"),
      attribute.style("padding", "2rem 1rem"),
      attribute.style("font-family", "'Helvetica Neue', Arial, sans-serif"),
      attribute.style("text-align", "center"),
      attribute.style("color", "#333"),
    ],
    [
      html.h1(
        [
          attribute.style("font-size", "2rem"),
          attribute.style("margin-bottom", "1.5rem"),
          attribute.style("letter-spacing", "0.05em"),
        ],
        [html.text(page_title)],
      ),
      html.figure(
        [attribute.style("margin", "0")],
        [
          html.img([
            attribute.src(moke_src),
            attribute.alt(moke_caption),
            attribute.style("max-width", "100%"),
            attribute.style("border-radius", "12px"),
            attribute.style("box-shadow", "0 4px 16px rgba(0,0,0,0.15)"),
          ]),
          html.figcaption(
            [
              attribute.style("margin-top", "0.75rem"),
              attribute.style("font-size", "0.9rem"),
              attribute.style("color", "#666"),
            ],
            [html.text(moke_caption)],
          ),
        ],
      ),
    ],
  )
}

pub fn main() {
  let app = lustre.element(view())
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
