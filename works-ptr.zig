const p_fgv &@import("fgv.zig").fgv;
test "works" {
    @import("std").debug.assert(p_fgv.* == 123);
}
