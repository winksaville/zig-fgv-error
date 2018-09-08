const p_fgv = &@import("fgv.zig").fgv;
test "works" {
    const assert = @import("std").debug.assert;
    assert(p_fgv.* == 123);
    p_fgv.* = 456; // Should probably be a compiler error: cannot assign to constant?
    assert(p_fgv.* == 123);
    //assert(p_fgv.* == 456); // assertion fails
}
