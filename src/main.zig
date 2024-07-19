const std = @import("std");

const c = @cImport({
    @cInclude("stdio.h");
});

const sqlite = @cImport({
    @cInclude("sqlite3.h");
});

pub fn main() !void {
    // Get SQLite3 version
    const sqlite_version = sqlite.sqlite3_libversion();
    std.debug.print("{s}\n", .{sqlite_version});

    // Open a SQLite3 database
    var db: ?*sqlite.sqlite3 = null;
    const rc = sqlite.sqlite3_open("mydata.db", &db);
    defer _ = std.debug.print("SQL CLOSED?: {d}\n", .{sqlite.sqlite3_close(db)});
    if (rc != sqlite.SQLITE_OK) {
        std.debug.print("Can't open database: {s}\n", .{sqlite.sqlite3_errmsg(db)});
    }

    // Test LibC import
    const ret = c.printf("hello from c world!\n");
    std.debug.print("C call return value: {}\n", .{ret});

    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
