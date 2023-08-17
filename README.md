# Nifty

This repo contains some example use cases for NIFs in Rust (with rustler) and Zig (with zigler).

The main app can be run with `iex -S mix run --no-halt` and provides a bare-bones FaaS setup that allows uploading WASM functions at `http://localhost:4000/index.html`.

The file at [`./test/wasm_out.wasm`](./test/wasm_out.wasm) provides a function that echoes the URL and used for the demo.

## Scheduler demo

The script at [`./scheduler.exs`](./scheduler.exs) can be executed to showcase blocking when not using the dirty CPU config for nifs. Execute with `./scheduler.exs --` and `./scheduler.exs -- d` for both variants

## Slides

Find slides that accompany the code at [`./slides.pdf`](./slides.pdf)