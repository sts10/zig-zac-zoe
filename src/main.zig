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
        var move_to_make: usize = 0;
        if (player_number == 1) {
            move_to_make = askUserForMove(board);
        } else {
            move_to_make = alfredPick(board) catch {
                std.debug.panic("Error: Can't find a valid move!\n", .{});
            };
        }

        board = execute_player_move(move_to_make, player_number, board) catch {
            std.debug.panic("Error making move!\n", .{});
        };
        presentBoard(board);
        // checkForWinningPlayer returns an "optional", which I take to be kind of like an Option
        // in Rust.
        // https://ziglearn.org/chapter-1/#optionals
        // Though it looks like you have to check for null _first_?
        var winner = checkForWinningPlayer(board);
        if (winner != null) {
            if (winner.? == 1) {
                std.debug.print("Player 1 wins!\n", .{});
                game_over = true;
            } else if (winner.? == 2) {
                std.debug.print("Player 2 wins!\n", .{});
                game_over = true;
            }
        }

        if (checkIfBoardIsFull(board)) {
            std.debug.print("Board is full! It's a draw.\n", .{});
            game_over = true;
        }
    }
}

const MoveError = error{
    NoOpenOfThree,
    OutOfBounds,
    AlreadyOccupied,
    Unreadable,
};
// I think this is the right way to write a function that changes an array
// https://ziglang.org/documentation/0.6.0/#Pass-by-value-Parameters
// I kind of like it, especially compared to the myriad of choices you face writing Rust!
fn execute_player_move(this_move_position: usize, player_number: u8, board: [9]u8) ![9]u8 {
    var new_board = board;
    if (new_board[this_move_position] == 0) {
        if (player_number == 1) {
            new_board[this_move_position] = 1;
        } else if (player_number == 2) {
            new_board[this_move_position] = 10;
        }
    } else {
        const err: MoveError = MoveError.AlreadyOccupied;
        return err;
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

// checkForWinningPlayer returns an "optional", which I take to be kind of like Rust Options
// https://ziglearn.org/chapter-1/#optionals
fn checkForWinningPlayer(board: [9]u8) ?u8 {
    var winner: ?u8 = null;
    const sums = calcSums(board);
    for (sums) |sum| {
        if (sum == 3) {
            winner = 1;
        } else if (sum == 30) {
            winner = 2;
        }
    }
    return winner;
}

fn checkIfBoardIsFull(board: [9]u8) bool {
    var board_sum: u8 = 0;
    for (board) |this_space| {
        board_sum += this_space;
    }
    return board_sum >= 45;
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

fn pickRandomNumber(max: usize) usize {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        // Ignoring possible error for code simplicity
        std.os.getrandom(std.mem.asBytes(&seed)) catch {};
        break :blk seed;
    });
    const rand = prng.random();

    const number = rand.intRangeAtMost(usize, 0, max);
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
fn findAnOpenOfThree(a: usize, b: usize, c: usize, board: [9]u8) !usize {
    if (isOpen(a, board)) {
        return a;
    } else if (isOpen(b, board)) {
        return b;
    } else if (isOpen(c, board)) {
        return c;
    } else {
        const err: MoveError = MoveError.NoOpenOfThree;
        return err;
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

fn alfredPick(board: [9]u8) !usize {
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
    } catch {
        // alfred_move could be an error (though this will actually never happen because of how alfredFindLine works)
        // so we catch it here, returning (or "bubbling up") the error to be handled higher up.
        const err: MoveError = MoveError.NoOpenOfThree;
        return err;
    };
    return alfred_move;
}

// Copied this wholesale from a SO answer. Don't feel good about it...
// https://stackoverflow.com/a/62077901
fn askUserForUsize(prompt: []const u8) !usize {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buf: [10]u8 = undefined;

    try stdout.print("{s}", .{prompt}); // not entirely sure what this {s} is about...

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        return std.fmt.parseInt(usize, user_input, 10);
    } else {
        const err: MoveError = MoveError.Unreadable;
        return err;
    }
}

fn askUserForMove(board: [9]u8) usize {
    // Wonder if there's a better way to structure this loop...
    while (true) {
        // Zig has no concept of strings! So we use an array of u8s here. Fascinating!
        const prompt: []const u8 = "Make your move! ";
        // askUserForUsize() may return either an usize or an error (if Zig was unable to
        // parse entered character as a usize).
        // Note: This "either value or error" type is called an "error union type" in Zig
        // https://ziglang.org/documentation/0.9.1/#toc-Error-Union-Type
        // We'll handle it with an if/else.
        // if we got a value (move) back, we'll change validMove to true and return move.
        if (askUserForUsize(prompt)) |move| {
            // Check if this selected move space is open
            if (isOpen(move, board)) {
                return move;
            } else {
                std.debug.print("Already occupied. Try again.\n", .{});
            }
        } else |err| {
            std.debug.print("Error: {}; try again.\n", .{err});
        }
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
