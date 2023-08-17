defmodule Nifty.Zifs do
  use Zig, otp_app: :nifty

  ~Z"""
  pub fn equality(value1: f64, value2: f64) bool {
    return value1 > value2;
  }
  """

  ~Z"""
  const std = @import("std");
  const ArrayList = std.ArrayList;
  const beam = @import("beam");

  pub fn alloc_vec(env: beam.env) !beam.term {
    const slice = try beam.allocator.alloc(u16, 4);
    defer beam.allocator.free(slice);

    for (slice) |*item, index| {
        item.* = @intCast(u16, index);
    }

    return beam.make(env, slice, .{});
  }
  """
end
