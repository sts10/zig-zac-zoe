// Run file with `zig build run`
const std = @import("std");

// pub fn main() anyerror!void {
//     std.log.info("All your codebase are belong to us.", .{});
// }
pub fn main() void {
    std.debug.print("Hello, {s}!\n", .{"World"});
    const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
    var i: u8 = 0;
    while (i < 5) {
        std.debug.print("elem: {}\n", .{a[i]});
        i += 1;
    }
    // reset our counter
    i = 0;
    // Alternate way to do a while loop
    // (like old-school for loop)
    while (i < 5) : (i += 1) {
        std.debug.print("elem: {}\n", .{a[i]});
    }
    for (a) |char| {
        std.debug.print("elem from for loop: {}\n", .{char});
    }

    // var game_over: bool = false;
    // var turn_number = 0;
    var board = [9]u8{ 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    for (board) |space, j| {
        std.debug.print("{}", .{space});
        // std.debug.print(" | ", .{});

        if ((j > 0) AND ((j + 1) % 3 == 0)) {
            std.debug.print("\n", .{});
        } else {
            std.debug.print(" | ", .{});
        }
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
