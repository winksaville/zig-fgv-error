test "works" {
    const fgv = @import("fgv.zig").fgv;
    @import("std").debug.assert(fgv == 123);
}
