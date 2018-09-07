use @import("fgv.zig");
test "works" {
    const assert = @import("std").debug.assert;
    assert(fgv == 123);
    fgv = 456;
    assert(fgv == 456);
}
