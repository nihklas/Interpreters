const std = @import("std");
const Allocator = std.mem.Allocator;
const Zli = @import("Zli");
const Scanner = @import("compiler/Scanner.zig");
const Parser = @import("compiler/Parser.zig");
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
    // const source = "a = true and false or 5 > 9 or 8 == 9; print 1;";
    const source =
        \\ print a <= true;
        \\ {
        \\      print 1 == 1;
        \\      {
        \\          1 == 2;
        \\          "hello";
        \\      }
        \\ }
    ;

    var scanner = Scanner.init(source);
    var parser = Parser.init(alloc, &scanner);
    defer parser.deinit();

    const ast = parser.parse();
    if (ast) |program| {
        std.debug.print("Got a tree\n", .{});
        @import("compiler/ast.zig").PrettyPrinter.print(program) catch unreachable;
    }
}

fn run() void {}
