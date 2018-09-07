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

But importing the global variable as a global const causes a compile error:
```bash
$ cat error.zig 
const fgv = @import("fgv.zig").fgv;
test "error" {
    @import("std").debug.assert(fgv == 123);
}
wink@wink-desktop:~/prgs/ziglang/zig-fgv-bug (master)
$ zig test error.zig 
error.zig:1:31: error: unable to evaluate constant expression
const fgv = @import("fgv.zig").fgv;
                              ^
```
