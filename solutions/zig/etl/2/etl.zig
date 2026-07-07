const std = @import("std");
const mem = std.mem;

pub fn transform(allocator: mem.Allocator, legacy: std.AutoHashMap(i5, []const u8)) mem.Allocator.Error!std.AutoHashMap(u8, i5) {
    var new = std.AutoHashMap(u8, i5).init(allocator);
    var iterator = legacy.iterator();
    while (iterator.next()) |entry| {
        for (entry.value_ptr.*) |value| {
            try new.put(std.ascii.toLower(value), entry.key_ptr.*);
        }
    }
    return new;
}
