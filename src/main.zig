// Run file with `zig build run`
const std = @import("std");

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
    // presentBoard(board);
    // board = changeBoard(board);
    presentBoard(board);

    var game_over = false;
    var turn_number: u8 = 0;
    while (game_over != true) : (turn_number += 1) {
        var player_number: u8 = 0;
        if (turn_number % 2 == 1) {
            player_number = 1;
        } else {
            player_number = 2;
        }
        // ask_user() may return either an usize for an error called an "error union type"
        // https://ziglang.org/documentation/0.9.1/#toc-Error-Union-Type
        // There are a number of ways to handle this type of error, though since we're in main, we
        // can't bubble the error up anywhere.
        // For now I'm going to do the equivalent of .unwrap_or(0)
        var num = ask_user() catch 0;
        std.debug.print("You entered {}\n", .{num});
        board = execute_player_move(num, player_number, board);
        presentBoard(board);
    }
}

// I think this is the right way to write a function that chagnes an array
// https://ziglang.org/documentation/0.6.0/#Pass-by-value-Parameters
// fn changeBoard(board: [9]u8) [9]u8 {
//     var new_board = board;
//     new_board[0] = 100;
//     return new_board;
// }

// I think this is the right way to write a function that chagnes an array
// https://ziglang.org/documentation/0.6.0/#Pass-by-value-Parameters
fn execute_player_move(this_move_position: usize, player_number: u8, board: [9]u8) [9]u8 {
    var new_board = board;
    if (new_board[this_move_position] == 0) {
        if (player_number == 1) {
            new_board[this_move_position] = 1;
        } else if (player_number == 2) {
            new_board[this_move_position] = 10;
        }
    } else {
        std.debug.panic("Position {} is occupied!", .{this_move_position});
    }
    return new_board;
}

// void says we're not going to return anything
fn presentBoard(board: [9]u8) void {
    for (board) |space, j| {
        // Could be a match or switch
        if (space == 0) {
            std.debug.print("{}", .{j});
        } else if (space == 1) {
            std.debug.print("O", .{});
        } else if (space == 10) {
            std.debug.print("X", .{});
        }

        if (j > 0 and (j + 1) % 3 == 0) {
            std.debug.print("\n", .{});
        } else {
            std.debug.print(" | ", .{});
        }
    }
}

// Copied this wholesale from a SO answer. Don't feel good about
// it...
// https://stackoverflow.com/a/62077901
fn ask_user() !usize {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buf: [10]u8 = undefined;

    try stdout.print("A number please: ", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        return std.fmt.parseInt(usize, user_input, 10);
    } else {
        return @as(usize, 0);
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
