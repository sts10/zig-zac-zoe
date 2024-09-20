
```zig
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
```

## Testing in Zig

Just a note to myself:
```zig
test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
```
