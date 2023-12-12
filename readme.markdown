# Zig Zac Zoe

Writing a very basic command-line tic-tac-toe game in [Zig](https://ziglang.org) as a way of learning the very basics of the language. I also wrote [a blog post about this project](https://sts10.github.io/2022/08/20/a-summer-fling-with-zig.html).

Previously, I did this in [Rust](https://github.com/sts10/rusty-tac) and [Go](https://github.com/sts10/tic-tac-go) as [a learning exercise in those two languages](https://sts10.github.io/2017/11/18/trying-go-and-rust.html).

## Running this thing

Once Zig is installed (see below), you should be able to run this program with the following command:
```bash
zig build run
```

This program should work with Zig v0.12 (tested with `v0.12.0-dev.1814+5c0d58b71`).

Note that most of the code work is in `src/main.zig`.

## Installing Zig

Consult [the Zig GitHub README](https://github.com/ziglang/zig#installation) for installation options. 

I think I installed Zig by running: `snap install zig --classic --edge`, as listed in [Zig's GitHub wiki](https://github.com/ziglang/zig/wiki/install-zig-from-a-package-manager). I originally wrote this program running v0.9.1.

## Zig resources I found
* [Official Zig docs for current version of Zig](https://ziglang.org/documentation/master/)
* [Official Zig docs for v 0.9.1](https://ziglang.org/documentation/0.9.1/) 
* [ziglearn.org](https://ziglearn.org/)
* [Zig by example](https://zig-by-example.com/)
* [Ziglings](https://codeberg.org/ziglings/exercises/) (think this requires an edge version of Zig?)
* [A long video of a beginner Zig programmer who's coming from Rust](https://www.youtube.com/watch?v=O4UYT-brgrc)
