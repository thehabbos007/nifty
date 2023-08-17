use core::slice;

use serde_json::Value;

#[no_mangle]
pub fn handle(bytes: *mut u8, length: usize) -> (*const u8, usize) {
    let slice = unsafe { slice::from_raw_parts(bytes, length) };
    let response = request_handler(slice);

    let response = response.into_boxed_str();
    let response = Box::leak(response);

    (response.as_ptr(), response.len())
}

pub fn request_handler(input: &[u8]) -> String {
    let parsed: Option<Value> = serde_json::from_slice(input).ok();

    let path = (parsed.as_ref())
        .and_then(|v| v.get("path"))
        .map(|v| {
            v.as_array()
                .to_owned()
                .unwrap()
                .into_iter()
                .map(|v| v.as_str().unwrap().to_owned())
                .collect::<Vec<_>>()
        })
        .unwrap_or(vec!["not_found".to_owned()]);

    format!("Got path: {:?}", path)
}
