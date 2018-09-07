test "works" {
    const assert = @import("std").debug.assert;
    const fgv = @import("fgv.zig").fgv;
    assert(fgv == 123);
    fgv = 456; // Compiler error: cannot assign to constant
    assert(fgv == 456);
}
