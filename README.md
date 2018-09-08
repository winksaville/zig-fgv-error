## Zig import global variable compile error

I created a file with a global variable:
```bash
$ cat fgv.zig 
pub var fgv: u64 = 123;
```

Importing the global variable as a local const in a funtion works:
```bash
$ cat works.zig 
test "works" {
    const fgv = @import("fgv.zig").fgv;
    @import("std").debug.assert(fgv == 123);
}

$ zig test works.zig 
Test 1/1 works...OK
All tests passed.
```

And I can `use` fgv:
```bash
$ cat works-use.zig
use @import("fgv.zig");
test "works" {
    @import("std").debug.assert(fgv == 123);
}
wink@wink-desktop:~/prgs/ziglang/zig-fgv-error (master)
$ zig test works-use.zig 
Test 1/1 works...OK
All tests passed.
```

And I can change it to a pointer:
```bash
$ cat works-ptr.zig 
const p_fgv &@import("fgv.zig").fgv;
test "works" {
    @import("std").debug.assert(p_fgv.* == 123);
}

$ zig test works-ptr.zig 
/home/wink/prgs/ziglang/zig-fgv-error/works-ptr.zig:1:13: error: expected token ';', found '&'
const p_fgv &@import("fgv.zig").fgv;
            ^
```

But importing the global variable as a global const causes a compile error:
```bash
$ cat error-unable-to-evaluate-constant-expression.zig 
const fgv = @import("fgv.zig").fgv;
test "error" {
    @import("std").debug.assert(fgv == 123);
}

$ cat error-unable-to-evaluate-constant-expression.zig 
const fgv = @import("fgv.zig").fgv;
test "error" {
    @import("std").debug.assert(fgv == 123);
}

$ zig test error-unable-to-evaluate-constant-expression.zig 
error-unable-to-evaluate-constant-expression.zig:1:31: error: unable to evaluate constant expression
const fgv = @import("fgv.zig").fgv;
                              ^
```

Also, read and write of fgv works with `use`:
```bash
$ cat works-use-rw.zig 
use @import("fgv.zig");
test "works" {
    const assert = @import("std").debug.assert;
    assert(fgv == 123);
    fgv = 456;
    assert(fgv == 456);
}

$ zig test works-use-rw.zig 
Test 1/1 works...OK
All tests passed.
```

But, you get a compiler error when writing to fgv as a local const:
```bash
$ cat error-cannot-assign-to-constant.zig
test "works" {
    const assert = @import("std").debug.assert;
    const fgv = @import("fgv.zig").fgv;
    assert(fgv == 123);
    fgv = 456; // Compiler error: cannot assign to constant
    assert(fgv == 456);
}

$ zig test error-cannot-assign-to-constant.zig
/home/wink/prgs/ziglang/zig-fgv-error/error-cannot-assign-to-constant.zig:5:9: error: cannot assign to constant
    fgv = 456; // Compiler error: cannot assign to constant
        ^
```

Based on the above generating a compiler error then writing using const pointer
should probably do the same thing but it doesn't. Although if you assert(p_fgv.* == 456)
that does fail:
```bash
$ cat works-but-should-probably-be-error-cannot-assign-to-constant.zig 
const p_fgv = &@import("fgv.zig").fgv;
test "works" {
    const assert = @import("std").debug.assert;
    assert(p_fgv.* == 123);
    p_fgv.* = 456; // Should probably be a compiler error: cannot assign to constant?
    assert(p_fgv.* == 123);
    //assert(p_fgv.* == 456); // assertion fails
}

$ zig test works-but-should-probably-be-error-cannot-assign-to-constant.zig 
Test 1/1 works...OK
All tests passed.
```
