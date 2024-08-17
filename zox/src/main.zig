const std = @import("std");
const Allocator = std.mem.Allocator;
const Zli = @import("Zli");
const Scanner = @import("compiler/Scanner.zig");
const Token = @import("compiler/Token.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const alloc = gpa.allocator();

    var zli = Zli.init(alloc);
    defer zli.deinit();

    try zli.addOption("help", 'h', "Show this Help message");
    try zli.addOption("compile", 'c', "Compile a .lox file into a .zox file");
    try zli.addOption("run", 'r', "Run a .zox file. Only needed in combination with --compile");
    try zli.addOption("output", 'o', "Alternative file path to output the compilation output");

    try zli.addArgument("input", "Either the .lox or .zox file to take in");

    if (try zli.option(bool, "help")) {
        _ = try zli.help(std.io.getStdOut().writer(), 0);
        return;
    }

    // TODO: Hook up the correct options and CLI Logic

    compile(alloc);
}

fn compile(alloc: Allocator) void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();
    _ = aa;

    const source =
        \\ +-/* // operators
        \\ {()} // grouping
        \\ ! != = == < <= > >= // comparisons
        \\ 12 34.5 // numbers
        \\ "test" // string
        \\ ident // identifier
        \\ // keywords
        \\ and
        \\ else
        \\ false
        \\ for
        \\ fun
        \\ if
        \\ nil
        \\ or
        \\ print
        \\ return
        \\ true
        \\ var
        \\ while
    ;

    var scanner = Scanner.init(source);
    var token: Token = scanner.nextToken();
    while (token.type != .EOF) : (token = scanner.nextToken()) {
        std.debug.print("Token: {}\n", .{token});
    }
}

fn run() void {}
