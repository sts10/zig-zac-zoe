// Run file with `zig build run`
const std = @import("std");

pub fn main() void {
    std.debug.print("Let's play... Zig Zac Zoe!\n\n", .{});

    var board = [9]u8{ 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    presentBoard(board);

    var game_over = false;
    var turn_number: u8 = 0;
    while (game_over != true) : (turn_number += 1) {
        // Not sure if this is good Zig...
        var player_number: u8 = 0;
        if (turn_number % 2 == 0) {
            player_number = 1;
        } else {
            player_number = 2;
        }
        var num: usize = 0;
        if (player_number == 1) {
            // ask_user() may return either an usize for an error called an "error union type"
            // https://ziglang.org/documentation/0.9.1/#toc-Error-Union-Type
            // There are a number of ways to handle this type of error, though since we're in main, we
            // can't bubble the error up anywhere.
            // For now I'm going to do the equivalent of .unwrap_or(0)
            num = ask_user() catch 0;
            // std.debug.print("You entered {}\n", .{num});
        } else {
            // num = findRandomOpenMove(board);
            num = alfredPick(board);
        }

        board = execute_player_move(num, player_number, board);
        presentBoard(board);
        var winner = checkForWinningPlayer(board);
        if (winner == 1) {
            std.debug.print("Player 1 wins!\n", .{});
            game_over = true;
        } else if (winner == 2) {
            std.debug.print("Player 2 wins!\n", .{});
            game_over = true;
        }

        if (checkIfBoardIsFull(board)) {
            std.debug.print("Board is full! It's a draw.\n", .{});
            game_over = true;
        }
    }
}

// I think this is the right way to write a function that changes an array
// https://ziglang.org/documentation/0.6.0/#Pass-by-value-Parameters
// I knid of like it, especially compared to the myriad of choices you face writing Rust!
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

fn calcSums(board: [9]u8) [8]u8 {
    var sums = [8]u8{ 0, 0, 0, 0, 0, 0, 0, 0 };
    sums[0] = board[2] + board[4] + board[6];
    sums[1] = board[0] + board[3] + board[6];
    sums[2] = board[1] + board[4] + board[7];
    sums[3] = board[2] + board[5] + board[8];
    sums[4] = board[0] + board[4] + board[8];
    sums[5] = board[6] + board[7] + board[8];
    sums[6] = board[3] + board[4] + board[5];
    sums[7] = board[0] + board[1] + board[2];
    return sums;
}

fn checkForWinningPlayer(board: [9]u8) u8 {
    const sums = calcSums(board);
    for (sums) |sum| {
        if (sum == 3) {
            return 1;
        } else if (sum == 30) {
            return 2;
        }
    }
    // No winner yet!
    return 0;
}

fn checkIfBoardIsFull(board: [9]u8) bool {
    var board_sum: u8 = 0;
    for (board) |this_space| {
        board_sum += this_space;
    }
    return board_sum == 54;
}

// Setting void as thje return type basically says we're not going to return anything
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

const RndGen = std.rand.DefaultPrng;
var rnd = RndGen.init(0);
fn pickRandomNumber(max: usize) usize {
    var number = @mod(rnd.random().int(usize), max);
    std.debug.print("Picking {}\n", .{number});
    return number;
}

fn findRandomOpenMove(board: [9]u8) usize {
    var move: usize = pickRandomNumber(8);
    while (true) {
        if (board[move] == 0) {
            break;
        } else {
            std.debug.print("{} isn't free?\n", .{move});
            move = pickRandomNumber(8);
        }
    }
    return move;
}

fn isOpen(desired_move: usize, board: [9]u8) bool {
    if (board[desired_move] == 0) {
        return true;
    } else {
        return false;
    }
}

// Given 3 usizes representing spaces on the board, find the first that
// is open
fn findAnOpenOfThree(a: usize, b: usize, c: usize, board: [9]u8) usize {
    if (isOpen(a, board)) {
        return a;
    } else if (isOpen(b, board)) {
        return b;
    } else if (isOpen(c, board)) {
        return c;
    } else {
        return 11; // clearly a cop out... think we're supposed to use an error?
    }
}

fn alfredFindLine(board: [9]u8) usize {
    var sums = calcSums(board);
    for (sums) |line_sum, i| {
        if (line_sum == 20) {
            return i;
        }
    }
    for (sums) |line_sum, i| {
        if (line_sum == 2) {
            return i;
        }
    }
    for (sums) |line_sum, i| {
        if (line_sum == 10) {
            return i;
        }
    }
    // If no good moves to choose, just pick randomly
    return findRandomOpenMove(board);
}
fn alfredPick(board: [9]u8) usize {
    var line_we_like = alfredFindLine(board);
    var alfred_move = switch (line_we_like) {
        0 => findAnOpenOfThree(2, 4, 6, board),
        1 => findAnOpenOfThree(0, 3, 6, board),
        2 => findAnOpenOfThree(1, 4, 7, board),
        3 => findAnOpenOfThree(2, 5, 8, board),
        4 => findAnOpenOfThree(0, 4, 8, board),
        5 => findAnOpenOfThree(6, 7, 8, board),
        6 => findAnOpenOfThree(3, 4, 5, board),
        7 => findAnOpenOfThree(0, 1, 2, board),
        else => findRandomOpenMove(board),
    };
    return alfred_move;
}

// Copied this wholesale from a SO answer. Don't feel good about
// it...
// https://stackoverflow.com/a/62077901
fn ask_user() !usize {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buf: [10]u8 = undefined;

    try stdout.print("Make your move! ", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        return std.fmt.parseInt(usize, user_input, 10);
    } else {
        return @as(usize, 0);
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
