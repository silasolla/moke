// globalThis.setTimeout が Gleam の標準ライブラリにないため FFI 経由で呼ぶ
export function setTimeoutFn(callback, ms) {
  globalThis.setTimeout(callback, ms);
}
