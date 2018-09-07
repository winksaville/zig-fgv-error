const fgv = @import("fgv.zig").fgv;
test "error" {
    @import("std").debug.assert(fgv == 123);
}
