# Zig Zac Zoe

Writing a very basic command-line tic-tac-toe game in [Zig](https://ziglang.org) as a way of learning the very basics of the language. I also wrote [a blog post about this project](https://sts10.github.io/2022/08/20/a-summer-fling-with-zig.html).

Previously, I did this in [Rust](https://github.com/sts10/rusty-tac) and [Go](https://github.com/sts10/tic-tac-go) as [a learning exercise in those two languages](https://sts10.github.io/2017/11/18/trying-go-and-rust.html).

## Installing Zig

**Note**: This program doesn't run correctly with Zig 0.10. It _does_ seem to work just fine with Zig version `0.11.0-dev.632+d69e97ae1`. See [this issue](https://github.com/ziglang/zig/issues/12258) for more.

At the time of this writing, you can install 0.11 by running `snap install zig --classic --edge`, as listed in [Zig's GitHub wiki](https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager). I originally wrote this program running v0.9.1.

## Running this thing

Run my program with `zig build run`. Most of the code work is in `src/main.zig`.

## Zig resources I found
* [Official Zig docs for v 0.9.1](https://ziglang.org/documentation/0.9.1/) <!-- https://ziglang.org/documentation/master/std/#root -->
* [ziglearn.org](https://ziglearn.org/)
* [Zig by example](https://zig-by-example.com/)
* [Ziglings](https://github.com/ratfactor/ziglings) (think this requires an edge version of Zig?)
* [A long video of a beginner Zig programmer who's coming from Rust](https://www.youtube.com/watch?v=O4UYT-brgrc)
