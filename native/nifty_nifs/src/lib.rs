use std::{thread, time::Duration};

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn sleep(duration_ms: u64) -> () {
    thread::sleep(Duration::from_millis(duration_ms));
}

#[rustler::nif(schedule = "DirtyCpu")]
fn sleep_dirty(duration_ms: u64) -> () {
    thread::sleep(Duration::from_millis(duration_ms));
}

#[rustler::nif]
fn alloc_vec() -> Vec<u16> {
    vec![0, 1, 2, 3]
}

rustler::init!("Elixir.Nifty.Rifs", [add, sleep, sleep_dirty, alloc_vec]);
